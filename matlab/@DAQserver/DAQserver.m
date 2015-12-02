% DAQSERVER - create an DAQ server to listen for connections and sample
% the DAQ card.
%
% d = DAQserver(port,maxsamplerate,channels,dllpath,sampletype,range,numChannelsTotal,debug)
%
% set channels to the channels to sample
% sampletype = 2 -> digital input, 4 -> analog input, 5 -> analog input AND digital output
%
% The DAQserver will sample as fast as possible, so specify in
% maxsamplerate the maximum it will do (to avoid buffer overflows)
%
% numChannelsTotal = the total number of input channels. This usually determines whether the board will be
%                    single-sided or differential [this is ignored for digital input]
%
% Note that if sampletype = 5, channels should be a cell array with 2
% values - the analog channels to sample, and the digital port (e.g. 1 for AUXPORT1, see cbw.h for the full list)
%
% e.g.
% d = DAQserver(3001,6000,1:3,'D:\cbw',2);
% listen(d);
%
% e.g.
% d = DAQserver(3001,6000,{1:3,1},'D:\cbw',2,3);

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

if ~any(sampletype==[2 4 5])
    error('Sampletype must be either 2 (digital input / RT measurement), 4 (analog input) or 5 (analog input + digital output)');
end

d.codes = messagecodes;
d.bits = channels;
d.sampletype = sampletype;
d.numChannelsTotal = numChannelsTotal;

if d.sampletype==2
    d.t = MCDAQ(dllpath,d.sampletype);
elseif any(d.sampletype==[4 5])
    d.t = MCDAQ(dllpath,d.sampletype,channels,range,numChannelsTotal);
else
    error('Unknown sample type, must be 2 (digital input),4 (analog input) or 5 (analog input + digital output)');
end

d = class(d,'DAQserver',socketserver(port,maxsamplerate,debug));