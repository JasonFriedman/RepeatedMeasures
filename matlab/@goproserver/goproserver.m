% GOPROSERVER - create a gopro server to listen for connections and tell
% the camera to start / stop recording
% 
% gs = goproserver(port,debug)
%
% e.g. 
% gs = goproserver(3030,1);
% listen(ts);
%

function gs = goproserver(port,debug)

gs.codes = messagecodes;

if nargin<2 || isempty(debug)
    debug = 0;
end

gs = class(gs,'goproserver',socketserver(port,1,debug));

% Try to connect to the gopro (so that if it fails, it will cause an error)
gopro('VideoMode');
fprintf('Gopro set to video mode\n');