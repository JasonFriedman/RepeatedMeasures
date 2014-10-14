% CLOSE - close the COM port
%
% close(s)

function close(s)

IOPort('Close',s.s);