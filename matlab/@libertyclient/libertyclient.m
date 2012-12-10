% LIBERTYCLIENT - create an object to connect to the libery server and send commands to it 
%
% lc = libertyclient(inputParams,experiment,debug)
% inputParams.server is the server to connect to (for this machine, use 'localhost')
% inputParams.port is the TCP/IP port to connect on
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [lc,params] = libertyclient(inputParams,experiment,debug)

params.name = {'numsensors','hemisphere','recordOrientation','samplerate','alignmentframe','displayRangeX','displayRangeY','offsetX','offsetY','showPositionColor'};
params.type = {'number','matrix_1_3','number','number','matrix_1_9','matrix_n_7','matrix_n_7','number','number','matrix_1_3'};
params.description = {'Number of liberty receivers present','The hemisphere to use (should be a 1x3 vectors, e.g. [0 0 1] means use the +z hemisphere)',...
'Whether to record orientation as well as position (so each data sample has 6 numbers rather than 3)',...
'Sample rate (can be either 120 or 240 (in Hz))','a 1x9 vector with the alignment frame. The first 3 are the zero position, the next three the direction of the x axis, the next three the direction of the y axis (in the coordinates of the transmitter cube',...
'Range of values to show when using showPosition as the dot position on the x axis. The ith row corresponds to the ith sensor. Use the first two values to show the liberty x values, next two for y, last two for z, e.g. [-10 10 0 0 0 0 0] to show x values of -10 to 10 as the dot x position. Use the last value to show time, e.g. [0 0 0 0 0 0 1] will move across the screen in 1 s',... 
'Range of values to show when using showPosition as the dot position on the y axis. The ith row corresponds to the ith sensor. Use the first two values to show the liberty x values, next two for y, last two for z, e.g. [0 0 0 0 -10 10 0] to show z values of -10 to 10 as the dot y position. Use the last value to show time, e.g. [0 0 0 0 0 0 1] will move up the screen in 1 s.',...
'x offset when using showPosition','y offset when using showPosition','color to show dot when using showPosition (each number between 0 and 255)'}; 
params.required = [1 0 0 0 0 0 0 0 0 0];
params.default = {1,[0 0 1],0,240,[0 0 0 1 0 0 0 1 0],[-10 10 0 0 0 0 0],[0 0 0 0 -10 10 0],0,0,[192 192 192]};
params.classdescription = 'Connect to the liberty to sample from it';
params.classname = 'liberty';
params.parentclassname = 'socketclient';

if nargout>1
    lc = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[lc,parent] = readParameters(params,inputParams);
   
lc = class(lc,'libertyclient',socketclient(parent,experiment,debug));
