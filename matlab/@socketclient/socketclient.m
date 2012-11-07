% SOCKETCLIENT - create an object for connection via a socket to recording device
%
% sc = socketclient(server,port,experiment,debug,noack)
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

params.name = {'server','port'};
params.type = {'string','number'};
params.description = {'Location of the server (e.g. ''localhost'' or an IP address) ',...
    'Port to connect to the server on'};
params.required = [1 1];
params.default = {'',0};
params.classdescription = 'The is the superclass for all the socket clients, which connect to the servers which sample the devices';
params.classname = 'socketclient';

if nargout>1
    sc = [];
    return;
end

sc = readParameters(params,inputParams);

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
