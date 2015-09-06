% SERIALPORTSERVER - create a server to listen for connections and sample via the serial port
% (e.g. for communication with an Arduino)
%
% d = serialportserver(port,maxsamplerate,COMport,baudrate,debug)
%
% The serial port will sample as fast as possible, so specify in
% maxsamplerate the maximum it will do (to avoid buffer overflows)
%
% e.g.
% s = serialportserver(3009,150);
% listen(s);

function s = serialportserver(port,samplerate,COMport,baudRate,debug)

if nargin<5 || isempty(debug)
    debug = 0;
end

s.codes = messagecodes;
s.COMport = COMport;
s.baudRate = baudRate;
s.protocol = 'Arduino';
s.s = [];

s = class(s,'serialportserver',socketserver(port,samplerate,debug));

% Connect to the client
s.s = serialport(s.COMport,s.baudRate,debug);
