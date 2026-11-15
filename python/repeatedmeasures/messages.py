"""Message and event codes (port of matlab/messagecodes.m)."""
from enum import IntEnum


class Command(IntEnum):
    """Commands sent from the experiment to a device server."""

    CLOSE_SOCKET = 1
    SETUP_RECORDING = 2
    START_RECORDING = 3
    STOP_RECORDING = 4
    GET_SAMPLE = 5
    GET_DATA_SUMMARY = 6
    MARK_EVENT = 7
    SAVE_FILE = 8
    START_WITHOUT_RECORD = 9
    GET_BUTTONS = 10
    INITIALIZE_DEVICE = 11
    IS_SERVER_RUNNING = 12
    CLOSE_DEVICE = 13
    GET_PREVIOUS_SAMPLE = 14


class Event(IntEnum):
    """Values written in the last (marker) column of the data files."""

    FIRST_FRAME = 5
    LAST_FRAME = 6
    BEEPED = 7
    SOUND_PLAYED = 8
    STIMULUS_ON = 10
    TRIGGER_SENT = 20  # + value sent
    DRT_START = 60
    DRT_TIMEOUT = 61
    DRT_PRESSED = 62
    IMAGE_STATE = 100  # + state
    TARGET_ON = 1000  # + target number
    TACTORED = 2000  # + sequence number
