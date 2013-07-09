% DAQSERVER - create an DAQ server to listen for connections and sample
% the DAQ card.
%
% d = DAQserver(port,maxsamplerate,channels,dllpath,sampletype,range,debug)
%
% set channels to the channels to sample
% sampletype = 2 -> digital input, 4 -> analog input
%
%
% The DAQserver will sample as fast as possible, so specify in
% maxsamplerate the maximum it will do (to avoid buffer overflows)
%
% e.g.
% d = DAQserver(3001,6000,1:3,'D:\cbw',2);
% listen(d);

function d = DAQserver(port,maxsamplerate,channels,dllpath,sampletype,range,debug)

if nargin<5 || isempty(sampletype)
    sampletype=2;
end

if nargin<6 || isempty(debug)
    debug = 0;
end

if sampletype~=2 && sampletype~=4
    error('Sampletype must be either 2 (digital input / RT measurement) or 4 (analog input)');
end

d.codes = messagecodes;
d.bits = channels;
d.sampletype = sampletype; 
if d.sampletype==2
    d.t = MCDAQ(dllpath,d.sampletype);
else
    d.t = MCDAQ(dllpath,d.sampletype,channels,range);
end

d = class(d,'DAQserver',socketserver(port,maxsamplerate,debug));