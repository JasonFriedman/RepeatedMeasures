% TABLETCLIENT - create an object to connect to the tablet server and send commands to it
%
% tc = tabletclient(inputParams,experiment,debug)
% inputParams.server is the server to connect to (for this machine, use 'localhost')
% inputParams.port is the TCP/IP port to connect on
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list
%
% inputParams.maxx and inputParams.maxy are the maximum x and y values in tablet coordinates
% for the DTZ2100 (Cintiq 21UX) it is 43600, 32799

function [tc,params] = tabletclient(inputParams,experiment,debug)

params.name = {'maxx','maxy','showPositionOnlyWhenTouching'};
params.type = {'number','number','number'};
params.description = {'Maximum x value in tablet coordinates (43600 for the Cintiq 21UX)',...
    'Maximum y value in tablet coordinates (32799 for the Cintiq 21UX)',...
    ['Whether to show position only when touching (0=also when not touching, 1=only when touching). If this is 0, then note that '...
    'showPositionColor can have in the second row the color for when the pen is not touching']};

params.required = [1 1 0];
params.default = {1,1,1};
params.classdescription = 'Connects to server to sample location and other information from a WACOM tablet';
params.classname = 'tablet';
params.parentclassname = 'socketclient';

if nargout>1
    tc = [];
    return;
end

[tc,parent] = readParameters(params,inputParams);

tc = class(tc,'tabletclient',socketclient(parent,experiment,debug));
