% LIBERTYSERVER - create a liberty server to listen for connections and sample from the liberty
%
% l = libertyserver(port,samplerate,numsensors,recordOrientation,sampleContinuously,COMport,debug)
%
% The liberty will sample as fast as possible, so specify in
% maxsamplerate (usually 240) the maximum it will do (to avoid buffer overflows)
%
% COMport is the serial port number the liberty is connected to, the default is 1
%
% e.g.
% l = libertyserver(3015,240,1,1,1,1);
% listen(l);

function l = libertyserver(port,samplerate,numsensors,recordOrientation,sampleContinuously,COMport,debug)

l.numsensors = [];
l.COMport = [];
l.s = [];
l.sampleContinuously = 1; % whether to record continuously (faster but may introduce lag) or each time request a sample
l.samplingContinuously = 0; % used to know whether continous sampling has been turned on yet
l.recordOrientation = 0;

l.codes = messagecodes;

if nargin<3 || isempty(numsensors)
    l.numsensors = 1;
else
    l.numsensors = numsensors;
end

if nargin>3 && ~isempty(recordOrientation)
    l.recordOrientation = recordOrientation;
end

if nargin>4 && ~isempty(sampleContinuously)
    l.sampleContinuously = sampleContinuously;
end

if nargin<6 || isempty(COMport)
    l.COMport = 1;
else
    l.COMport = COMport;
end

if nargin<7 || isempty(debug)
    debug = 0;
end

l = class(l,'libertyserver',socketserver(port,samplerate,debug));

% Connect to the serial port
COMportname = ['COM' num2str(l.COMport)];
l.s = IOPort('OpenSerialPort',COMportname,'BaudRate=115200 Terminator=13');

if debug
    fprintf(['Connected on port ' COMportname '\n']);
end

% Clear anything on the port
inBuffer = IOPort('BytesAvailable',l.s);
if inBuffer>0
    IOPort('Read',l.s);
end
