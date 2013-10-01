% FORCESENSORSCLIENT - create an object to connect to the DAQ server and send commands to it
%
% fc = forcesensorsclient(inputParams,experiment,debug)
% inputParams.server is the server to connect to (for this machine, use 'localhost')
% inputParams.port is the TCP/IP port to connect on
% inputParams.numchannels = numbers of channels to sample (must agree with the number of channels specified when running DAQserver)
% inputParams.gains = gains for the sensors (1 x numchannels array)
% inputParams.offsets = offsets for the sensors (1 x numchannels array)
%
% The force for each sensor is calculated as offset(k) + gain(k)*DAQvoltage(k)
%
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% Note that this should be run with DAQserver (there is no forcesensorsserver)
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [fc,params] = forcesensorsclient(inputParams,experiment,debug)

params.name = {'gains','offsets','displayRangeX','displayRangeY','offsetX','offsetY','showPositionColor','filterType','filterOrder','filterCutoff','samplerate'};
params.type = {'matrix','matrix','matrix_n_3','matrix_n_3','number','number','matrix_n_3','string','number','matrix','number'};
params.description = {'Gains (one per channel), usually in N / V','Offsets (one per channel), usually in N',...
    'Range of values to show when using showPosition as the dot position on the x axis. The ith row corresponds to the ith sensor. Use the first two values to show the range of force values e.g. [0 10] to show values of 0 to 10 as the dot x position. Use the last value to show time, e.g. [0 0 1] will move across the screen in 1 s',... 
    'Range of values to show when using showPosition as the dot position on the y axis. The ith row corresponds to the ith sensor. Use the first two values to show the range of force values e.g. [0 10] to show values of 0 to 10 as the dot y position. Use the last value to show time, e.g. [0 0 1] will move up the screen in 1 s.',...
'x offset when using showPosition','y offset when using showPosition','color to show dot when using showPosition (each number between 0 and 255). The ith row corresponds to the ith sensor (if applicable)',...
'Filter to apply if showing position (current only option is ''butter'' for Butterworth filter). Note that filtering is only for onscreen display, and the saved data is not filtered. Use of a filter requires the signal processing toolkit. An empty string means no filtering.',...
'If using a filter, which order to use','If using a filter, the cutoff frequency for a lowpass filter (in Hz). If 2 numbers are specified, a bandpass filter will be created.','Sample rate (in Hz), only needed if using a filter'};
params.required = [1 1 0 0 0 0 0 0 0 0 0];
params.default = {1,0,[0 0 1],[0 1 0],0,0,[255 0 0],'',4,8,150};
params.classdescription = 'This client connects to a DAQ server to sample force sensors.';
params.classname = 'forcesensors';
params.parentclassname = 'DAQclient';

if nargout>1
    fc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[fc,parent] = readParameters(params,inputParams);

fc = class(fc,'forcesensorsclient',DAQclient(parent,experiment,debug));
