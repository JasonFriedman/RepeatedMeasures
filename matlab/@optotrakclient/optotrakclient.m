% OPTOTRAKCLIENT - create an object to connect to the optotrak server and send commands to it
%
% oc = optotrakclient(server,port,numbermarkers,experiment,secondaryhost,collectionParameters,debug)
%
% server is the server to connect to (for this machine, use 'localhost')
%
% port is the TCP/IP port to connect on
%
% numbermarkers = numbers of markers currently being used
%
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
%
% if secondaryhost=1, optotrak will run as a secondary host (need another
% computer running as primary host), if 0 will run as primary host
%
% collectionParameters (only needed / used for primary host) describe the
% collection parameters, e.g:
%
%   coll.NumMarkers      =   2;          %Number of markers in the collection.
%   coll.FrameFrequency  = 200;        %Frequency to collect data frames at.
%   coll.MarkerFrequency =3000;       %Marker frequency for marker maximum on-time.
%   coll.Threshold       =  30;         %Dynamic or Static Threshold value to use.
%   coll.MinimumGain     = 160;        %Minimum gain code amplification to use.
%   coll.StreamData      =   1;          %Stream mode for the data buffers.
%   coll.DutyCycle       = 0.4;        %Marker Duty Cycle to use.
%   coll.Voltage         = 7.5;        %Voltage to use when turning on markers.
%
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://www.mathworks.com/matlabcentral/fileexchange/11130

function [oc,params] = optotrakclient(inputParams,experiment,debug)

coll.NumMarkers      =6;          %Number of markers in the collection.
coll.FrameFrequency  =50 ;        %Frequency to collect data frames at.
coll.MarkerFrequency =2500;       %Marker frequency for marker maximum on-time.
coll.Threshold       =30;         %Dynamic or Static Threshold value to use.
coll.MinimumGain     =160;        %Minimum gain code amplification to use.
coll.StreamData      =1;          %Stream mode for the data buffers.
coll.DutyCycle       =0.4;        %Marker Duty Cycle to use.
coll.Voltage         =7.5;        %Voltage to use when turning on markers.
coll.CollectionTime  =4;          %Number of seconds of data to collect.
coll.PreTriggerTime  =0;

collectionParams.name = {'FrameFrequency','MarkerFrequency','Threshold','MinimumGain','DutyCycle','Voltage'};
collectionParams.type = {'number','number','number','number','number','number'};
collectionParams.description = {'Number of markers to collect from',...
    'Frequency to sample at',...
    'Dynamic or static threshold value',...
    'Minimum gain code amplification',...
    'Marker duty cycle (how long the marker is on',...
    'Voltage to use for markers'};
collectionParams.required = [1 1 1 1 1 1];
collectionParams.default = {200,3000,30,160,0.550,9.335};
collectionParams.classdescription = 'Collection parameters for the optotrak';
collectionParams.classname = 'collectionParams';

params.name = {'numbermarkers','secondaryhost','collectionParameters'};
params.type = {'number','number',collectionParams};
params.description = {'Number of optotrak markers present','whether this computer is a secondary host','The collection parameters (see OptotrakToolbox and optotrak documentation for more details)'};
params.required = [1 1 1];
params.default = {[],0,[]};
params.classdescription = 'Connects to the optotrak to sample 3D locations';
params.classname = 'optotrak';
params.parentclassname = 'socketclient';

if nargout>1
    oc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[oc,parent] = readParameters(params,inputParams);

if nargin>0
    oc.collectionParameters.NumMarkers = oc.numbermarkers;
    oc = class(oc,'optotrakclient',socketclient(parent,experiment,debug));
else
    oc = class(oc,'optotrakclient',socketclient('',0,[],0));
end