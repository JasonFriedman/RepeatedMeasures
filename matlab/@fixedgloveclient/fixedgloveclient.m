% FIXEDGLOVECLIENT - create an object to use a fixed joint angles in place of a cyberglove
%
% This is to be used in place of gloveclient, when you want the joint angles of
% the hand to be fixed (i.e. without using a real glove)
%
% tc = fixedgloveclient(inputParams,experiment,debug)
%
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages

function [tc,params] = fixedgloveclient(inputParams,experiment,debug)

params.name = {'jointangles'};
params.type = {'matrix_1_23'};
params.description = {'Joint angles of the hand (in degrees)'};
params.required = [0];
params.default = {zeros(1,23)};
params.classdescription = 'Use fixed joint angles in place of a glove.';
params.classname = 'fixedglove';

if nargout>1
    tc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[tc,parent] = readParameters(params,inputParams);

tc = class(tc,'fixedgloveclient',gloveemulatorclient(parent,experiment,debug));
