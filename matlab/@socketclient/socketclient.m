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
    'showPositionRotationCenter','showPositionRotationAngle','displayRangeX','displayRangeY','offsetX','offsetY'};
params.type = {'string','number','string','cellarray','matrix','cellarray','matrix_n_1','cellarray','cellarray','number','number'};
params.description = {'Location of the server (e.g. ''localhost'' or an IP address) ',...
    'Port to connect to the server on',...
    ['If showing position, how to show the current position (either ''dot'',''ellipse'', ''rectangle'' or ''image''). Note that if showPosition=1, it will always be shown. If showPosition=2 and imagestimulus is used,' ...
    'it will only be shown when in state 1']',...
    'If showing position, the color of the feedback (each number between 0 and 255). If showing image, the imagenumber to show. If it is a cell array, then each cell can specify for an individual trial.',...
    'If showing position and showPositionType is a dot, the size of the dot (in pixels). If type is a rectangle, then a 1x2 array (width and height)',...
    'If showing position, the center of rotation (if showPositionRotationAngle is not zero)',...
    'If showing position, the angle to rotate about the center of rotation (in radians)',...
    'Range of values to show when using showPosition=3 as the dot position on the x axis. The ith row corresponds to the ith sensor. Use the first two values to show the x values, next two for y. e.g. [-1 1 0 0 0] to show x values of -1 to 1 as the dot x position. Use the last value to show time, e.g. [0 0 0 0 1] will move across the screen in 1 s. This should be a cell array with either a single cell for all trials, or a cell for each trial.',... 
    'Range of values to show when using showPosition=3 as the dot position on the y axis. The ith row corresponds to the ith sensor. Use the first two values to show the x values, next two for y, e.g. [0 0 -10 10 0] to show y values of -0.5 to 0.5 as the dot y position. Use the last value to show time, e.g. [0 0 0 0 1] will move up the screen in 1 s. This should be a cell array with either a single cell for all trials, or a cell for each trial.',...
    'x offset when using showPosition.  This can either be a single number (same for every trial), or an Nx1 matrix (one for each trial).',...
    'y offset when using showPosition.  This can either be a single number (same for every trial), or an Nx1 matrix (one for each trial).'};
params.required = [1 1 0 0 0 0 0 0 0 0 0];
params.default = {'localhost',0,'dot',[192 192 192],6,{[0.5 0.5]},NaN,{[0 0 0 0 0]},{[0 0 0 0 0]},0.5,0.5};
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
if iscell(sc.showPositionColor)
    for k=1:numel(sc.showPositionColor)
        if ischar(sc.showPositionColor{k})
            sc.showPositionColor{k} = str2num(sc.showPositionColor{k}); %#ok<ST2NM>
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
