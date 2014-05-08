% TACTOR - class for connecting and sending commands to a tactor
% This is designed for tactors from Engineering Acoustics, Inc
% Communication is either via the serial port, accessing using the IOPort command
% from psychtoolbox, or using bluetooth (using the Matlab instrument control toolbox)
% 
% t = tactor(COMport); or
% t = tactor(remoteName);
%
% where remoteName is the bluetooth "RemoteName", as can be identified
% using the command:
% instrhwinfo('Bluetooth')

function t = tactor(COMport,debug)

t.COMport = COMport;
t.connectionType = [];

if nargin<2 || isempty(debug)
    debug = 0;
end

t.debug = debug;

if ~isnan(str2double(COMport))
    COMport = str2double(COMport);
end

if isnumeric(COMport)
    t.connectionType = 1; % Serial
else
    t.connectionType = 2; % Bluetooth
end

if t.connectionType==1
    t.s = IOPort('OpenSerialPort',['COM' num2str(t.COMport)],'BaudRate=115200');
elseif t.connectionType==2
    t.s = Bluetooth(t.COMport,1);
    pause(1.0);
    fopen(t.s);
end

t = class(t,'tactor');
readmessage(t); % clear the buffer


