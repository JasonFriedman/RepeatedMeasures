% G4CLIENT - create an object to connect to the g4 server and send commands to it 
%
% lc = g4client(inputParams,experiment,debug)
% inputParams.server is the server to connect to (for this machine, use 'localhost')
% inputParams.port is the TCP/IP port to connect on
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list
%
% When using show positition: 
%
% showPosition = 1 = show one dot, the sum of the values in displayRangeX / DisplayRangeY, 
% showPosition = 2 = each markers has its own dot (set displayRange to NaN to not show a dot for a marker)
% 

function [lc,params] = g4client(inputParams,experiment,debug)

params.name = {'numsensors'};
params.type = {'number'};
params.description = {'Number of g4 receivers present'};

params.required = [1];
params.default = {1};
params.classdescription = 'Connect to the g4 to sample from it';
params.showPositionValues = 'Each sensor gives 3 values: x, y and z. displayRangeX and displayRangeY have 7 columns: [xmin xmax ymin ymax zmin zmax time]. With several sensors, use one row for each sensor (numsensors rows); a single row is used for every sensor, and the movements of all the sensors are added.';
params.classname = 'g4';
params.parentclassname = 'socketclient';

if nargout>1
    lc = [];
    return;
end

if nargin<1 || isempty(inputParams)
    error('g4client requires inputParams');
end

if nargin<2 || isempty(experiment)
    error('g4client requires experiment');
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[lc,parent] = readParameters(params,inputParams);

    
lc = class(lc,'g4client',socketclient(parent,experiment,debug));

% Use a one-row displayRangeX / displayRangeY for every sensor
% (each cell is a trial, so repeat the rows within each cell)
lc.socketclient = repeatRowsForSensors(lc.socketclient,lc.numsensors,3);