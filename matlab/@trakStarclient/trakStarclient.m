% TRAKSTARCLIENT - create an object to connect to the trakStar server and send commands to it 
%
% tc = trakStarclient(inputParams,experiment,debug)
% inputParams.server is the server to connect to (for this machine, use 'localhost')
% inputParams.port is the TCP/IP port to connect on
% inputParams.numReceivers is the number of receivers that will be used
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [tc,params] = trakStarclient(inputParams,experiment,debug)

params.name = {'numsensors','hemisphere','range'};
params.type = {'number','string','number'};
params.description = {'Number of trakStar receivers present','Hemisphere to use, should be one of: FRONT,BACK,TOP,BOTTOM,LEFT or RIGHT','Tracking range in inches. can be 36,72 or 144'};
params.required = [1 0 0];
params.default = {[],'FRONT',36};
params.classdescription = 'Connect to a trakStar server to record trakStar 6D data';
params.classname = 'trakStar';
params.parentclassname = 'socketclient';

if nargout>1
    tc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[tc,parent] = readParameters(params,inputParams);
   
tc = class(tc,'trakStarclient',socketclient(parent,experiment,debug));
