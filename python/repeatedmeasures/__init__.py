"""Groundwork for a Python port of RepeatedMeasures.

protocol   read and validate the existing XML protocol files (port of readParameters /
           validate), driven by schema.json, which is exported from the MATLAB code
messages   the message and event codes (port of messagecodes.m)
devices    a language neutral device protocol (JSON lines over TCP) with a server base
           class, a client and a simulated device
"""
from .protocol import Protocol, ProtocolError, load_protocol, load_schema  # noqa: F401

__version__ = "0.0.1"
