% MOUSECLIENT - create an object to connect to the mouse server and send commands to it 
%
% mc = mouseclient(server,port,maxx,maxy,experiment,debug)
% server is the server to connect to (for this machine, use 'localhost')
% port is the TCP/IP port to connect on
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
%
% maxx, maxy are the screen resolution, so that getsample will provide 
% the mouse position in the range 0-1
%
% This class requires that "MSocket" be in the path. The program is
% available from http://code.google.com/p/msocket/downloads/list

function [mc,params] = mouseclient(inputParams,experiment,debug)

params.name = {'maxx','maxy','showPositionType','showPositionColor','showPositionSize','displayRangeX','displayRangeY','offsetX','offsetY'};
params.type = {'number','number','string','matrix_1_3','matrix','matrix_n_5','matrix_n_5','number','number'};
params.description = {'Maximum x coordinate on the screen (i.e. horizontal screen width in pixels)',...
    'Maximum y coordinate on the screen (i.e. vertical screen height in pixels)',...
    'If showing position, how to show the current position (either ''dot'',''ellipse'' or ''rectangle'')',...
    'If showing position, the color of the feedback (each number between 0 and 255)',...
    'If showing position and showPositionType is a dot, the size of the dot (in pixels). If type is a rectangle, then a 1x2 array (width and height)',...
    'Range of values to show when using showPosition=3 as the dot position on the x axis. The ith row corresponds to the ith sensor. Use the first two values to show the mouse x values, next two for y. e.g. [-1 1 0 0 0] to show x values of -1 to 1 as the dot x position. Use the last value to show time, e.g. [0 0 0 0 1] will move across the screen in 1 s',... 
    'Range of values to show when using showPosition=3 as the dot position on the y axis. The ith row corresponds to the ith sensor. Use the first two values to show the liberty x values, next two for y, e.g. [0 0 -10 10 0] to show y values of -0.5 to 0.5 as the dot y position. Use the last value to show time, e.g. [0 0 0 0 1] will move up the screen in 1 s.',...
    'x offset when using showPosition','y offset when using showPosition'};

params.required = [1 1 0 0 0 0 0 0 0];
params.default = {0,0,'dot',[192 192 192],6,[0 0 0 0 0],[0 0 0 0 0],0.5,0.5};
params.classdescription = 'Connect to the mouse server to sample the mouse location';
params.classname = 'mouse';
params.parentclassname = 'socketclient';

if nargout>1
    mc = [];
    return;
end

[mc,mcParent] = readParameters(params,inputParams);
   
mc = class(mc,'mouseclient',socketclient(mcParent,experiment,debug));
