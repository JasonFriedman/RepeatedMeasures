% OPTOTRAKSERVER - create an optotrak server to listen for connections
%
% This uses the optotrak as either a primary host, or as a
% "secondary host" (in which case all the settings: number of markers,
% frequency, etc) should be set first on the primary host).
%
% o = optotrakserver(port,framerate,debug)
%
% port is the TCP/IP port to listen on
% if debug = 1, then display more messages (default=0)
%
% Typical usage (port 3000, 1000Hz sample rate):
%
% o = optotrakserver(3000,1000);
% listen(o);
% close(o);

function o = optotrakserver(port,framerate,debug)

if nargin<2 || isempty(debug)
    debug = 0;
end

o.codes = messagecodes;

o = class(o,'optotrakserver',socketserver(port,framerate,debug));
