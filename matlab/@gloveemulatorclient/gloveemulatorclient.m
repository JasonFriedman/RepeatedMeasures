% GLOVEEMULATORCLIENT - create an object to read glove data from a file
%
% This is to be used in place of gloveclient, when you want to read the
% glove data from a file rather than directly from the glove. It can also
% be used if there is no physical glove connected to the system
%
% gc = gloveemulatorclient(inputParams,experiment,debug)
%
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [gc,params] = gloveemulatorclient(inputParams,experiment,debug)

params.name = {};
params.type = {};
params.description = {};
params.required = [];
params.default = {};
params.classdescription = 'Read glove data from a file. The files should be in the directory "emulated" and the name of the file to read is specified in each trial in the filename field.';
params.classname = 'gloveemulator';

if nargout>1
    gc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[gc,parent] = readParameters(params,inputParams);

gc.data = []; % The data will be read in for each trial
   
gc = class(gc,'gloveemulatorclient');
