% GAZEPOINTSERVER - create a gazepoint server to listen for connections and sample
% the gazepoint eyetracker
%
% gs = gazepointserver(port,maxsamplerate,debug,fixationbox)
%
% The gazepointserver will sample as fast as possible, so specify in
% maxsamplerate the maximum it will do (to avoid buffer overflows)
%
% fixation box should be a 1 x 4 vector - [left top height width] - in
% relative coodinates (i.e. from 0 to 1)
%
% e.g.
% gs = gazepointserver(3021,100,0,[0.4 0.2 0.2 0.2],0.9);
% listen(gs);

function gs = gazepointserver(port,samplerate,debug,fixationbox,fixationratio)

gs.socket = [];

if nargin<3 || isempty(debug)
    debug = 0;
end

if nargin<4 || isempty(fixationbox)
    fixationbox = [];
elseif numel(fixationbox)~=4
    error('The fixationbox (4th argument) must have 4 elements - [left top height width], in relative coordinate');
end

if nargin<5 || isempty(fixationratio)
    fixationratio = NaN;
end

gs.codes = messagecodes;
gs.fixationbox = fixationbox;
gs.fixationratio = fixationratio;
gs.socket = connectToGazepoint;

gs = class(gs,'gazepointserver',socketserver(port,samplerate,debug));

% Do calibration
doCalibration(gs.socket,20);
