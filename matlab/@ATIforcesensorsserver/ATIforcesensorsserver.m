% ATIFORCESENSORSSERVER - create a server to listen for connections and sample ATI force sensors via wifi
%
% d = ATIforcesensorsserver(port,maxsamplerate,channels,IPaddress,debug)
%
% The server will sample as fast as possible, so specify in
% maxsamplerate the maximum it will do (to avoid buffer overflows)
%
% d = ATIforcesensorsserver(3011,200,3,'192.168.137.175',1);
% listen(d);
%
% NOTE: To use this server, you need to put the directory
% "wirelessftsensor" in this directory. It can be downloaded from the ATI
% website
% (https://www.ati-ia.com/Library/software/wireless_ft/WNetJavaDemoSource.zip)
% only this directory from the zip file is needed

function d = ATIforcesensorsserver(port,samplerate,channels,IPaddress,debug)

if nargin<5 || isempty(debug)
    debug = 0;
end

d.channels = channels;
d.IPaddress = IPaddress;
d.codes = messagecodes;

% These will be set when reading the calibration data
d.counts_per_N = 1;
d.counts_per_Nm = 1;

% add this directory to the java class path
[thedir,~,~] = fileparts(which('ATIforcesensorsserver'));
javaaddpath(thedir);
% Try to connect to the device
import wirelessftsensor.*;
d.v = javaObject('wirelessftsensor.WirelessFTSensor',IPaddress);

fprintf('Connected to wireless ATI sensors on IP %s\n',IPaddress);

d = class(d,'ATIforcesensorsserver',socketserver(port,samplerate,debug));