% DAQSERVER - create an DAQ server to listen for connections and sample
% the DAQ card (for an NI DAQ)
%
% d = NIDAQserver(port,maxsamplerate,inputdevice,inputchannels,outputdevice,outputchannels,debug)
%
% default inputdevice is ''
% default inputchannels is ''
% 
% default outputdevice is 'Dev1'
% default outputchannels is 'port0/line0'
%
% Requires the Matlab data acquisition toolbox
%
% The DAQserver will sample as fast as possible, so specify in
% maxsamplerate the maximum it will do (to avoid buffer overflows)
%
% e.g.
% d = NIDAQserver(3011,500,'Dev1','port1/line0',2);
% listen(d);

function d = NIDAQserver(port,maxsamplerate,inputdevice,inputchannels,outputdevice,outputchannels,debug)

if nargin<3 || isempty(inputdevice)
    inputdevice='';
end

if nargin<4 || isempty(inputchannels)
    inputchannels = '';
end

if nargin<5 || isempty(outputdevice)
    outputdevice='Dev1';
end

if nargin<6 || isempty(outputchannels)
    outputchannels = 'port1/line0';
end

if nargin<7 || isempty(debug)
    debug = 0;
end

d.codes = messagecodes;

d.dq = daq('ni');
d.numInput = 0;
d.numOutput = 0;
if ~isempty(inputdevice)
    [~,index] = addinput(d.dq,inputdevice,inputchannels,'Digital');
    d.numInput = numel(index);
end
if ~isempty(outputdevice)
    [~,index] = addoutput(d.dq,outputdevice,outputchannels,'Digital');
    d.numOutput = numel(index);
end

d = class(d,'NIDAQserver',socketserver(port,maxsamplerate,debug));