% SOCKETSERVER - a general purpose server that listens on a socket
%
% s = socketserver(port,framerate,debug)
% port is the TCP/IP port to listen on
% framerate is the frame rate (in samples per second (Hz))
% If debug=1, then the server will print more messages
%
% You should not use this class directly, rather one of its children
% e.g. optotrakserver
%
% This class requires that "MSocket" be in the path. The program is
% available from http://www.mathworks.com/matlabcentral/fileexchange/11130

function s = socketserver(port,framerate,debug)

s.port = [];
s.socket = [];
s.debug = [];
s.framerate = [];

s.port = port;
s.framerate = framerate;

if nargin<2 || isempty(debug)
    s.debug = 0;
else
    s.debug = debug;
end

% Set up the port for listening (don't actually start listening now though)
s.socket = mslisten(s.port);

if s.debug
    fprintf('Opened a socket on port %d with number %d\n',s.port,s.socket);
end

s = class(s,'socketserver');
