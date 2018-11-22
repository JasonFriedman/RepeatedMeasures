% ATIFORCESENSORSSERVER - create a server to listen for connections and sample ATI force sensors via wifi
%
% d = ATIforcesensorsserver(port,maxsamplerate,channels,IPaddress,debug)
%
% If channels is a cell array, this indicates that you can also send digital outputs (e.g. triggers)
% The first value should be the same as channels described above, and the second the channels for the digital output, 
% where 1 = AUXPORT1, etc. e.g. {[1 3],1}
%
% The server will sample as fast as possible, so specify in
% maxsamplerate the maximum it will do (to avoid buffer overflows)
%
% d = ATIforcesensorsserver(3011,200,3,'192.168.137.175',1);
% listen(d);

function d = ATIforcesensorsserver(port,samplerate,channels,IPaddress,debug)

if nargin<5 || isempty(debug)
    debug = 0;
end

d.channels = channels;
d.IPaddress = IPaddress;
d.codes = messagecodes;

% Try to connect to the device
javaaddpath('.');
import wirelessftsensor.*;
d.v = javaObject('wirelessftsensor.WirelessFTSensor',IPaddress);

fprintf('Connected to wireless ATI sensors on IP %s\n',IPaddress);

d = class(d,'ATIforcesensorsserver',socketserver(port,samplerate,debug));