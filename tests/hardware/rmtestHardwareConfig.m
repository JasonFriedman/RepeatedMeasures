% RMTESTHARDWARECONFIG - which real devices to test with runAllTests('hardware')
%
% Edit this file to list the device servers that are running (start them first, e.g. with
% runkeyboardserver / runtabletserver / runlibertyserver ...). Each entry is a struct with
%   name        the name of the client (the field used in the setup section of a protocol)
%   parameters  the parameters of the client, as in a protocol (server, port, ...)
%   prefix      prefix of the data file the server writes (e.g. 'kb_', 'mo_', 'tablet_')
%
% Devices whose server cannot be reached are reported as skipped, not as failed, so it is
% fine to leave devices in the list that are not always plugged in.
function devices = rmtestHardwareConfig
devices = {};
devices{end+1} = struct('name','keyboard','prefix','kb_',...
    'parameters',struct('server','localhost','port',3002));
devices{end+1} = struct('name','mouse','prefix','mo_',...
    'parameters',struct('server','localhost','port',3003,'maxx',1920,'maxy',1080));
% Examples (uncomment and adapt):
% devices{end+1} = struct('name','tablet','prefix','tablet_',...
%     'parameters',struct('server','localhost','port',3009,'maxx',48767,'maxy',30479));
% devices{end+1} = struct('name','liberty','prefix','liberty_',...
%     'parameters',struct('server','localhost','port',3015,'numsensors',1));
