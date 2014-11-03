% DAQSERVER - create an DAQ server to listen for connections and sample
% the DAQ card.
%
% d = DAQserver(port,maxsamplerate,channels,dllpath,sampletype,range,numChannelsTotal,debug)
%
% set channels to the channels to sample
% sampletype = 2 -> digital input, 4 -> analog input
%
% The DAQserver will sample as fast as possible, so specify in
% maxsamplerate the maximum it will do (to avoid buffer overflows)
%
% numChannelsTotal = the total number of input channels. This usually determines whether the board will be
%                    single-sided or differential [this is ignored for digital input]
%
% e.g.
% d = DAQserver(3001,6000,1:3,'D:\cbw',2);
% listen(d);

function d = DAQserver(port,maxsamplerate,channels,dllpath,sampletype,range,numChannelsTotal,debug)

if nargin<5 || isempty(sampletype)
    sampletype=2;
end

if nargin<7 || isempty(numChannelsTotal)
    numChannelsTotal = 8;
end

if nargin<8 || isempty(debug)
    debug = 0;
end

if sampletype~=2 && sampletype~=4
    error('Sampletype must be either 2 (digital input / RT measurement) or 4 (analog input)');
end

d.codes = messagecodes;
d.bits = channels;
d.sampletype = sampletype;
d.numChannelsTotal = numChannelsTotal;

if d.sampletype==2
    d.t = MCDAQ(dllpath,d.sampletype);
else
    d.t = MCDAQ(dllpath,d.sampletype,channels,range,numChannelsTotal);
end

d = class(d,'DAQserver',socketserver(port,maxsamplerate,debug));