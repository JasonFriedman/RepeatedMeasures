% STARTRECORDING - start recording with the gaze point server
% (i.e., put it into continuous mode)

function gs = startRecording(gs)

flush(gs.socket);
writeline(gs.socket,'<SET ID="ENABLE_SEND_TIME" STATE="1" />');
writeline(gs.socket,'<SET ID="ENABLE_SEND_POG_BEST" STATE="1" />');            
writeline(gs.socket,'<SET ID="ENABLE_SEND_DATA" STATE="1" />');
% Read the 3 ACK for the 3 commands
readline(gs.socket);
readline(gs.socket);
readline(gs.socket);

