% STOPRECORDING - stop recording from the device and close the inter
function cgs = stopRecording(cgs)

% Close the interface (so it can be reopened next time)
GloveMex(4);
cgs.isConnected = 0;
