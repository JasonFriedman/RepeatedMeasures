function disconnectFromGazepoint(s)

writeline(s, '<SET ID="ENABLE_SEND_DATA" STATE="0" />');
delete(s);
            
