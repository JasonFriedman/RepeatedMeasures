% TRACKEREMULATORCLIENT - create an object to read tracker data from a file
%
% This is to be used in place of fastrakclient, when you want to read the
% tracker data from a file rather than directly from a tracker. It can also
% be used if there is no physical tracker connected to the system
%
% tc = trackeremulatorclient(inputParams,experiment,debug)
%
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages

function [tc,params] = trackeremulatorclient(inputParams,experiment,debug)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'Read tracker data from a file. The files should be in the directory "emulated" and the name of the file to read is specified in each trial in the filename field.';
params.classname = 'trackeremulator';

if nargout>1
    tc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[tc,parent] = readParameters(params,inputParams);

tc.data = []; % for the loaded data

tc = class(tc,'trackeremulatorclient');
