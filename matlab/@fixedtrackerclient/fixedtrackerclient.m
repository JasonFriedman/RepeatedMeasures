% FIXEDTRACKERCLIENT - create an object to use a fixed position / orientation in place of a tracker
%
% This is to be used in place of fastrakclient, when you want the position / orientation of
% the hand to be fixed (i.e. without using a tracker)
%
% tc = fixedtrackerclient(inputParams,experiment,debug)
%
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages

function [tc,params] = fixedtrackerclient(inputParams,experiment,debug)

params.name = {'position','orientation'};
params.type = {'matrix_1_3','matrix_1_3'};
params.description = {'Position of the hand (x,y,z)','Orientation of the hand (Euler angles)'};
params.required = [0 0];
params.default = {[0 0 0],[0 0 0]};
params.classdescription = 'Use a fixed position / orientation in place of a tracker.';
params.classname = 'fixedtracker';

if nargout>1
    tc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[tc,parent] = readParameters(params,inputParams);

tc = class(tc,'fixedtrackerclient',trackeremulatorclient(parent,experiment,debug));
