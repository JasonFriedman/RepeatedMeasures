% stopRecording - stop streaming from the FastTrak

function fts = stopRecording(fts)

% Close the interface (so it can be reopened next time)
FastrakMex(3);
fts.isConnected = 0;
