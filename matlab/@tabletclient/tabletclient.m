% TABLETCLIENT - create an object to connect to the tablet server and send commands to it
%
% tc = tabletclient(inputParams,experiment,debug)
% inputParams.server is the server to connect to (for this machine, use 'localhost')
% inputParams.port is the TCP/IP port to connect on
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list
%
% inputParams.maxx and inputParams.maxy are the maximum x and y values in tablet coordinates
% for the DTZ2100 (Cintiq 21UX) it is 43600, 32799

function [tc,params] = tabletclient(inputParams,experiment,debug)

params.name = {'maxx','maxy','showPositionType','showPositionColor','showPositionSize','showPositionOnlyWhenTouching','displayRangeX','displayRangeY','offsetX','offsetY'};
params.type = {'number','number','string','matrix_n_3','matrix','boolean','matrix_n_5','matrix_n_5','number','number'};
params.description = {'Maximum x value in tablet coordinates (43600 for the Cintiq 21UX)',...
    'Maximum y value in tablet coordinates (32799 for the Cintiq 21UX)',...
    ['If showing position, how to show the current position (either ''dot'' or ''rectangle''). Note that if showPosition=1, it will always be shown. If showPosition=2 and imagestimulus is used,' ...
    'it will only be shown when in state 1'],...
    ['If showing position, the color of the feedback (each number between 0 and 255). If showPositionOnlyWhenTouching=0,',...
    'the second row of this matrix can have the color for when the pen is not touching'],...
    'If showing position and showPositionType is a dot, the size of the dot (in pixels). If type is a rectangle, then a 1x2 array (width and height)',...
    'Whether to show position only when touching (0=also when not touching, 1=only when touching)',...
    'Range of values to show when using showPosition=3 as the dot position on the x axis. The ith row corresponds to the ith sensor. Use the first two values to show the mouse x values, next two for y. e.g. [-1 1 0 0 0] to show x values of -1 to 1 as the dot x position. Use the last value to show time, e.g. [0 0 0 0 1] will move across the screen in 1 s',...
    'Range of values to show when using showPosition=3 as the dot position on the y axis. The ith row corresponds to the ith sensor. Use the first two values to show the liberty x values, next two for y, e.g. [0 0 -10 10 0] to show y values of -0.5 to 0.5 as the dot y position. Use the last value to show time, e.g. [0 0 0 0 1] will move up the screen in 1 s.',...
    'x offset when using showPosition','y offset when using showPosition'};

params.required = [1 1 0 0 0 0 0 0 0 0];
params.default = {1,1,'dot',[192 192 192],6,1,[0 0 0 0 0],[0 0 0 0 0],0.5,0.5};
params.classdescription = 'Connects to server to sample location and other information from a WACOM tablet';
params.classname = 'tablet';
params.parentclassname = 'socketclient';

if nargout>1
    tc = [];
    return;
end

[tc,parent] = readParameters(params,inputParams);

tc = class(tc,'tabletclient',socketclient(parent,experiment,debug));
