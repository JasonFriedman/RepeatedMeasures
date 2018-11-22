% ATIFORCESENSORSCLIENT - create an onject to connect to the ATI force sensors server and send commands to it
%
% fc = ATIforcesensorsclient(inputParams,experiment,debug)
%
% server is the server to connect to (for this machine, use 'localhost')
%
% port is the TCP/IP port to connect on
%
% numbersensors = numbers of sensors
%
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
%
% samplerate = sample rate for the force sensors
%
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://www.mathworks.com/matlabcentral/fileexchange/11130

function [fc,params] = ATIforcesensorsclient(inputParams,experiment,debug)

params.name = {'numsensors','samplerate'};
params.type = {'number','number'};
params.description = {'Number of force sensors present','Sample rate (in Hz)'};
params.required = [1 1];
params.default = {1,200};
params.classdescription = 'Connects to the ATI force sensors server';
params.classname = 'ATIforcesensorsclient';
params.parentclassname = 'socketclient';

if nargout>1
    fc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[fc,parent] = readParameters(params,inputParams);

fc = class(fc,'ATIforcesensorsclient',socketclient(parent,experiment,debug));
