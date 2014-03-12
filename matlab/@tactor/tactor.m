% TACTOR - class for connecting and sending commands to a tactor
% t = tactor(COMport);

function t = tactor(COMport,debug)

t.COMport = COMport;

if nargin<2 || isempty(debug)
    debug = 0;
end

t.debug = debug;

t.s = IOPort('OpenSerialPort',['COM' num2str(t.COMport)],'BaudRate=115200');
IOPort('Read',t.s); % clear anything in the buffer

t = class(t,'tactor');



