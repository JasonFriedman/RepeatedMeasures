% CLOSE - close the COM port for the tactor
%
% close(t)

function close(t)

IOPort('Close',t.s);