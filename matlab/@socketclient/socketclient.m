% SOCKETCLIENT - create an object for connection via a socket to recording device
%
% sc = socketclient(inputParams,experiment,debug,noack)
%
% server is the server to connect to (for this machine, use 'localhost')
% port is the TCP/IP port to connect on
% experiment is a pointer to the parent object (which must have a
% function called "writetolog",e.g. writetolog(experiment,'Message');
% If debug=1, then the client will print more messages
% If noack=1, it does not require an acknoledgement
%
% You should not use this class directly, rather one of its children
% e.g. optotrakclient
%
% This class requires that "MSocket" be in the path. The program is
% available from http://www.mathworks.com/matlabcentral/fileexchange/11130

function [sc,params] = socketclient(inputParams,experiment,debug,noack)

params.name = {'server','port','showPositionType','showPositionColor','showPositionSize',...
    'showPositionRotationCenter','showPositionRotationAngle','startRotationFrame','displayRangeX','displayRangeY','offsetX','offsetY'};
params.type = {'string','number','string','cellarray','matrix',...
    'cellarray','cellarray','matrix','cellarray','cellarray','matrix','matrix'};
params.description = {'Location of the server (e.g. ''localhost'' or an IP address) ',...
    'Port to connect to the server on',...
    ['If showing position, how to show the current position (either ''dot'',''ellipse'', ''rectangle'' or ''image'' or the name of a function with an @ before it). Note that if showPosition=1, it will always be shown. If showPosition=2 and imagestimulus is used,' ...
    'it will only be shown when in state 1. If showPosition=3, then the fields below will be used to determine the position. If showPosition=4, it is the same as 3, but the position is only shown until the trial starts. If using a function, the function will get called ' ...
    'every frame (data can be stored between calls in the thistrial struct): thistrial = yourFunctionName(experimentdata,thistrial,lastpositionVisual,e,frame);' ],...
    'If showing position, the color of the feedback (each number between 0 and 255). Should be a N * (P*3) array (P= number of dots). Can either have one row, or a row for each frame. If showing image, the imagenumber to show. If it is a cell array, then each cell can specify for an individual trial.',...
    'If showing position and showPositionType is a dot, then a 1*P array (with the size of the each dot in pixels. If type is a rectangle, then a 1*(P*2) array (width and height).',...
    'If showing position, the center of rotation (if showPositionRotationAngle is not zero). Should be a P * 2 matrix (p = number of dots), in relative screen coordinates (i.e. between 0 and 1)',...
    'If showing position, the angle to rotate about the center of rotation (in radians). Should be a P * 1 matrix (p = number of dots), or a cell for each trial with a P*1 matrix',...
    'If showing position, the frame to start the rotation (if there is one). To start before the trial (i.e. while waiting for start), set to -inf. Should be a 1*P  matrix (p=number of dots) or N*P (one row for each trial).',...
    'Range of values to show when using showPosition=3 as the dot position on the x axis. The ith row corresponds to the ith sensor. Use the first two values to show the x values, next two for y. e.g. [-1 1 0 0 0] to show x values of -1 to 1 as the dot x position. Use the last value to show time, e.g. [0 0 0 0 1] will move across the screen in 1 s. If the time (last) value is set to -inf, only show before trial starts. If set to inf, only show during (and not before) trial. This should be a cell array with either a single cell for all trials, or a cell for each trial. To show multiple points, use an M*(N*P) matrix (M sensors, N=2*dims+1, P dots)',... 
    'Range of values to show when using showPosition=3 as the dot position on the y axis. The ith row corresponds to the ith sensor. Use the first two values to show the x values, next two for y, e.g. [0 0 -10 10 0] to show y values of -0.5 to 0.5 as the dot y position. Use the last value to show time, e.g. [0 0 0 0 1] will move up the screen in 1 s. If the time (last) value is set to -inf, only show before trial starts. If set to inf, only show during (and not before) trial. This should be a cell array with either a single cell for all trials, or a cell for each trial. To show multiple points, use an M*(N*P) matrix (M sensors, N=2*dims+1, P dots)',...
    'x offset when using showPosition.  This can either be a 1*P matrix [P is the number of dots] (same for every trial), or an NxP matrix (one row for each trial).',...
    'y offset when using showPosition.  This can either be a 1*P matrix [P is the number of dots] (same for every trial), or an NxP matrix (one row for each trial).'};
params.required = [1 1 0 0 0 0 0 0 0 0 0 0];
params.default = {'localhost',0,'dot',[192 192 192],6,{[0.5 0.5]},{NaN},-inf,{[0 0 0 0 0]},{[0 0 0 0 0]},0.5,0.5};
params.classdescription = 'This is the superclass for all the socket clients, which connect to the servers which sample the devices';
params.classname = 'socketclient';

if nargout>1
    sc = [];
    return;
end

sc = readParameters(params,inputParams);

% Convert displayRangeX / displayRangeY to matrices
for k=1:numel(sc.displayRangeX)
    if ischar(sc.displayRangeX{k})
        sc.displayRangeX{k} = str2num(sc.displayRangeX{k}); %#ok<ST2NM>
    end
end
for k=1:numel(sc.displayRangeY)
    if ischar(sc.displayRangeY{k})
        sc.displayRangeY{k} = str2num(sc.displayRangeY{k}); %#ok<ST2NM>
    end
end
for k=1:numel(sc.showPositionRotationCenter)
    if ischar(sc.showPositionRotationCenter{k})
        sc.showPositionRotationCenter{k} = str2num(sc.showPositionRotationCenter{k}); %#ok<ST2NM>
    end
end
for k=1:numel(sc.showPositionRotationAngle)
    if iscell(sc.showPositionRotationAngle) && ischar(sc.showPositionRotationAngle{k})
        sc.showPositionRotationAngle{k} = str2num(sc.showPositionRotationAngle{k}); %#ok<ST2NM>
    end
end
if iscell(sc.showPositionColor)
    for k=1:numel(sc.showPositionColor)
        if ischar(sc.showPositionColor{k})
            sc.showPositionColor{k} = str2num(sc.showPositionColor{k}); %#ok<ST2NM>
        end
    end
end
if iscell(sc.showPositionType)
    spt = sc.showPositionType;
else
    spt{1} = sc.showPositionType;
end

for k=1:numel(spt)
    if ~any(strcmp(spt{k},{'dot','ellipse','rectangle','image'}))
        if sc.showPositionType(1)=='@'
            % Check that the function exists
            if exist(spt{k}(2:end))~=2
                error(['Cannot find function for showPosition ' spt(2:end)]);
            end
        else
            error(['Unknown showPositionType: ' spt{k}]);
        end
    end
end

sc.socket = [];
sc.debug = [];
sc.sock = [];
sc.experiment = [];

if nargin<2
    sc.experiment = logfilegenerator;
else
    sc.experiment = experiment;
end

if nargin<3 || isempty(debug)
    sc.debug = 0;
else
    sc.debug = debug;
end

if nargin<4 || isempty(noack)
    noack = 0;
end

% If sc.debug==-1, then don't connect
if sc.debug~=-1
    
    % Connect to the socket
    sc.sock = msconnect(sc.server,sc.port);
    
    if sc.sock==-1
        error('Could not connect to server!!!');
    end
    
    if ~noack
        received = msrecv(sc.sock,5);
        if isstruct(received) && isfield(received,'accepted') && received.accepted==1
            if sc.debug
                fprintf('Made a connection: %d\n',sc.sock);
            end
        else
            error('Did not receive acknowledgement of connection to server!!! Try restarting the server');
        end
    end
end

sc = class(sc,'socketclient');
