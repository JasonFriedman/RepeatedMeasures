% STOPRECORDING - stop recording from the device

function s = stopRecording(s)

% Stop recording
WinTabMex(3);
% Close the interface (so it can be reopened next time)
WinTabMex(1);
