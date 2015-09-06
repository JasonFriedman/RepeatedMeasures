function s = serialport(COMport,baudRate,debug)

s.COMport = COMport;
s.baudRate = baudRate;

if nargin<3 || isempty(debug)
    debug = 0;
end

s.debug = debug;

s.s = IOPort('OpenSerialPort',sprintf('\\\\.\\COM%d',s.COMport),sprintf('BaudRate=%d',s.baudRate));
s = class(s,'serialport');

readmessage(s); % clear the buffer
