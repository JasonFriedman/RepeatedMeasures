% FORCESENSORSSERVER - create a server to listen for connections and sample the DAQ card
%
% d = forcesensorsserver(port,maxsamplerate,channels,range,parameters,debug)
%
% parameters should be a 2 x N matrix (N is the number of channels)
% The first row is the offset, the second row the gain (Force in N = gain * (voltage - offset) )
%
% channels should be a 1 x 2 matrix, with [minChannelNumber maxChannelNumber]
%
% The server will sample as fast as possible, so specify in
% maxsamplerate the maximum it will do (to avoid buffer overflows)
%
% e.g.
% d = forcesensorsserver(3001,6000,[0 4],4,0);
% listen(d);

function d = forcesensorsserver(port,samplerate,channels,range,parameters,debug)

if nargin<6 || isempty(debug)
    debug = 0;
end

d.parameters = parameters;
d.codes = messagecodes;

if ~all(size(channels)==[1 2])
    error('Channels must be a 1x2 matrix');
end

channels
parameters
if ~all(size(parameters)==[2 (channels(2)-channels(1)+1)])
    error('Parameters must be a 2xN matrix (N=number of channels)');
end

d = class(d,'forcesensorsserver',DAQserver(port,samplerate,channels,'',4,range,debug));