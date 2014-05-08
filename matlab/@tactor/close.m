% CLOSE - close the COM port for the tactor
%
% close(t)

function close(t)

if t.connectionType==1
    IOPort('Close',t.s);
elseif t.connectionType==2
    fclose(t.s);
end