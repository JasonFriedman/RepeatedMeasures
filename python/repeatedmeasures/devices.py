"""A language neutral replacement for the msocket protocol.

The MATLAB version sends serialized MATLAB variables (msocket), so only MATLAB can talk to
a device server. Here every message is one line of JSON over TCP:

    -> {"command": "GET_SAMPLE"}                       <- {"ok": true, "data": [x, y, t, marker]}
    -> {"command": "SETUP_RECORDING", "filename": "results/s1/trial1", "max_seconds": 5}
    -> {"command": "MARK_EVENT", "value": 5}

so a device server can be written in any language (C++ next to a vendor SDK, Python,
or the existing MATLAB servers behind a small adapter), and it can run on another computer.

DeviceServer has the same structure as @socketserver/listen.m: subclasses only implement
read_sample (and optionally summarize / handle_command), exactly like the MATLAB servers
implement getsample / doCalculations / runcommand. Sampling runs in its own thread at the
requested rate instead of being interleaved with message handling.
"""
from __future__ import annotations

import csv
import json
import math
import socket
import socketserver
import threading
import time
from pathlib import Path
from typing import Any, Callable


class DeviceServer:
    prefix = "dev_"

    def __init__(self, host: str = "127.0.0.1", port: int = 0, rate: float = 200.0, clock: Callable[[], float] = time.perf_counter):
        self.rate = rate
        self.clock = clock
        self._lock = threading.Lock()
        self._buffer: list[list[float]] = []
        self._last: list[float] | None = None
        self._marker = 0.0
        self._recording = False
        self._sampling = False
        self._filename: Path | None = None
        self._summary: dict | None = None
        self._stop = threading.Event()
        outer = self

        class Handler(socketserver.StreamRequestHandler):
            def handle(self) -> None:
                self.wfile.write(b'{"accepted": true}\n')
                for line in self.rfile:
                    message = json.loads(line)
                    reply = outer._dispatch(message)
                    self.wfile.write((json.dumps(reply, allow_nan=True) + "\n").encode())
                    if message.get("command") == "CLOSE_SOCKET":
                        break

        class Server(socketserver.ThreadingTCPServer):
            allow_reuse_address = True
            daemon_threads = True

        self._server = Server((host, port), Handler)
        self.host, self.port = self._server.server_address[:2]
        self._threads = [threading.Thread(target=self._server.serve_forever, daemon=True), threading.Thread(target=self._sample_loop, daemon=True)]

    # ---- to be implemented by a device
    def read_sample(self) -> list[float]:
        raise NotImplementedError

    def summarize(self, data: list[list[float]]) -> dict:
        return {}

    def handle_command(self, command: str, message: dict) -> Any:
        raise ValueError(f"Unknown command {command}")

    # ---- common behaviour
    def start(self) -> "DeviceServer":
        for thread in self._threads:
            thread.start()
        return self

    def close(self) -> None:
        self._stop.set()
        self._server.shutdown()
        self._server.server_close()

    def _sample_loop(self) -> None:
        period = 1.0 / self.rate
        while not self._stop.is_set():
            if self._sampling:
                sample = [float(x) for x in self.read_sample()] + [self.clock()]
                with self._lock:
                    row = sample + [self._marker]
                    self._marker = 0.0
                    self._last = row
                    if self._recording:
                        self._buffer.append(row)
            self._stop.wait(period)

    def _dispatch(self, message: dict) -> dict:
        command = message.get("command", "")
        try:
            with self._lock:
                if command == "GET_SAMPLE":
                    return {"ok": True, "data": self._last}
                if command == "MARK_EVENT":
                    self._marker = float(message["value"])
                    return {"ok": True}
                if command == "SETUP_RECORDING":
                    target = Path(message["filename"])
                    self._filename = target.with_name(self.prefix + target.name + ".csv")
                    self._buffer = []
                    return {"ok": True, "file": str(self._filename)}
                if command in ("START_RECORDING", "START_WITHOUT_RECORD"):
                    self._recording = command == "START_RECORDING"
                    self._sampling = True
                    return {"ok": True}
                if command == "STOP_RECORDING":
                    if self._recording:
                        self._summary = self.summarize(self._buffer)
                    self._recording = self._sampling = False
                    return {"ok": True, "samples": len(self._buffer)}
                if command == "GET_DATA_SUMMARY":
                    return {"ok": True, "data": self._summary}
                if command == "SAVE_FILE":
                    if self._filename is None:
                        raise ValueError("SETUP_RECORDING must be sent before SAVE_FILE")
                    self._filename.parent.mkdir(parents=True, exist_ok=True)
                    with open(self._filename, "w", newline="") as fp:
                        csv.writer(fp).writerows(self._buffer)
                    return {"ok": True, "file": str(self._filename)}
                if command in ("CLOSE_SOCKET", "CLOSE_DEVICE", "INITIALIZE_DEVICE", "IS_SERVER_RUNNING"):
                    return {"ok": True}
            return {"ok": True, "data": self.handle_command(command, message)}
        except Exception as err:  # the error is reported to the client, the server keeps running
            return {"ok": False, "error": str(err)}


class SimulatedDevice(DeviceServer):
    """A device without hardware: a point moving on a circle (for tests and demos)."""

    prefix = "sim_"

    def read_sample(self) -> list[float]:
        t = self.clock()
        return [math.cos(t), math.sin(t)]

    def summarize(self, data: list[list[float]]) -> dict:
        return {"samples": len(data), "duration": data[-1][-2] - data[0][-2] if data else 0.0}


class DeviceClient:
    """The experiment side (port of @socketclient)."""

    def __init__(self, host: str, port: int, timeout: float = 5.0):
        self._socket = socket.create_connection((host, port), timeout=timeout)
        self._file = self._socket.makefile("rwb")
        if not json.loads(self._file.readline()).get("accepted"):
            raise ConnectionError("Did not receive acknowledgement of connection to server")

    def send(self, command: str, **parameters: Any) -> Any:
        self._file.write((json.dumps({"command": command, **parameters}) + "\n").encode())
        self._file.flush()
        reply = json.loads(self._file.readline())
        if not reply.get("ok"):
            raise RuntimeError(reply.get("error", "device error"))
        return reply.get("data", reply)

    def close(self) -> None:
        try:
            self.send("CLOSE_SOCKET")
        finally:
            self._socket.close()
