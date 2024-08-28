% STOPRECORDING - stop recording with the gazepointserver
% (i.e., take it out of continuous mode)

function gs = stopRecording(gs)

writeline(gs.socket,'<SET ID="ENABLE_SEND_DATA" STATE="0" />');
flush(gs.socket);

