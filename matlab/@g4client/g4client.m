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
params.classname = 'g4';
params.parentclassname = 'socketclient';

if nargout>1
    lc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[lc,parent] = readParameters(params,inputParams);

    
lc = class(lc,'g4client',socketclient(parent,experiment,debug));

displayRangeX = get(lc.socketclient,'displayRangeX');
% Fix displayRangeX / Y if necessary by repeating for the number of sensors
if size(displayRangeX,1)==1 && lc.numsensors>1
    displayRangeX = repmat(displayRangeX,lc.numsensors,1);
    lc.socketclient = set(lc.socketclient,'displayRangeX',displayRangeX);
    set(lc,'socketclient',lc.socketclient);
end

displayRangeY = get(lc.socketclient,'displayRangeY');
if size(displayRangeY,1)==1 && lc.numsensors>1
    displayRangeY = repmat(displayRangeY,lc.numsensors,1);
    lc.socketclient = set(lc.socketclient,'displayRangeY',displayRangeY);
    set(lc,'socketclient',lc.socketclient);

end