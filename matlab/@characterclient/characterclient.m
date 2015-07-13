% CHARACTERCLIENT - a client to connect to the character server
% Usually the client will be on a different computer / Android device
% This class is here primarily for testing / integration into other programs
%
% [cc,params] = characterclient(inputParams,experiment,debug)
%
% server is the server to connect to (for this machine, use 'localhost')
% port is the TCP/IP port to connect on
% If debug=1, then the client will print more messages
%
% e.g. to use standalone:
%
% inputParams.server = 'localhost';
% inputParams.port = '3033';
% cc = characterclient(inputParams,1);
%
% This class requires that "MSocket" be in the path. The program is
% available from http://www.mathworks.com/matlabcentral/fileexchange/11130

function [cc,params] = characterclient(inputParams,debug)

params.name = {'server','port'};
params.type = {'string','number'};
params.description = {'Location of the server (e.g. ''localhost'' or an IP address) ',...
    'Port to connect to the server on'};
params.required = [1 1];
params.default = {'localhost',0};
params.classdescription = 'The is a client to connect to a character server (over TCP/IP)';
params.classname = 'character';
params.parentclassname = 'socketclient';

if nargout>1
    cc = [];
    return;
end

if nargin<2 || isempty(debug)
    debug = 0;
end

cc = readParameters(params,inputParams);

cc.socket = [];
cc.debug = [];
cc.sock = [];

if nargin<2 || isempty(debug)
    cc.debug = 0;
else
    cc.debug = debug;
end

% Connect to the socket
cc.sock = msconnect(cc.server,cc.port);
    
if cc.sock==-1
    error('Could not connect to server!!!');
end
   
[received,success] = msrecvraw(cc.sock,1,5); % Receive 1 byte, timeout after 5 seconds
if(received(1)==1)
    if cc.debug
        fprintf('Made a connection: %d\n',cc.sock);
    end
else
    error('Did not receive acknowledgement of connection to server!!! Try restarting the server');
end

cc = class(cc,'characterclient');