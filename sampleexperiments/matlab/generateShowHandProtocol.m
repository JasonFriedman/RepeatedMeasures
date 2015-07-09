% GENERATESHOWHANDPROTOCOL - generate protocol for the ShowHand experiment.
%
% This experiment requires a cyberglove and fastrak, and that the
% virtualhand SDK is installed. The "master" program (part of the SDK)
% needs to be run before this experiment can be run
%
%
% generateShowHandProtocol(isEmulated)

function generateShowHandProtocol(isEmulated)

if nargin<1 || isempty(isEmulated)
    isEmulated = 0;
end


% These should be changed appropriately
if isEmulated
    filename = 'protocols/ShowHandEmulated.xml';
    showFlipped = 0;
    stereomode = 0;
else
    filename = 'protocols/ShowHand.xml';
    showFlipped = 1; 
    % upper half of screen is left eye, lower half is right eye
    % the monitor will make it look stereo. Set to 0 for mono
    % (or see Psychtoolbox documentation for other types of stereo)
    stereomode = 2;
end
% If using a mirror setup, you need to horizontally flip the display
% Set the frame rate to 30 Hz, because the computer cannot keep up with 60% Hz 
% (it is worthwhile changing this to find the fastest your computer can manage).
% Note that this is the display frame rate, not the recording framerate
framerate = 30;

if isEmulated
    experimentDescription.setup.glovetracker.glove.gloveemulator = struct();
    experimentDescription.setup.glovetracker.tracker.trackeremulator = struct();
else
    experimentDescription.setup.glovetracker.glove.glove.server = 'localhost';
    experimentDescription.setup.glovetracker.glove.glove.port = 3011;
    experimentDescription.setup.glovetracker.tracker.fastrak.server = 'localhost';
    experimentDescription.setup.glovetracker.tracker.fastrak.port = 3015;
    experimentDescription.setup.glovetracker.tracker.fastrak.numReceivers = 1;
end
experimentDescription.setup.framerate = framerate;

% Setup the VR environment
experimentDescription.setup.vr.translation = [-1.2 -8.1 21.6];
experimentDescription.setup.vr.scale = [0.5 0.5 0.5];
experimentDescription.setup.vr.rotate = [0 0 0];
experimentDescription.setup.vr.stereomode = stereomode;

experimentDescription.setup.vr.eyedistance = 0.6; %0.7;

% for when the monitor is vertical (standard way)
%experimentDescription.setup.vr.cameralocation = [0 2 22];
%experimentDescription.setup.vr.center = [5 5 5];
%experimentDescription.setup.vr.up = [0 1 0];
% for when the monitor is horizontal
experimentDescription.setup.vr.cameralocation = [0 20 0];
experimentDescription.setup.vr.center = [0 0 0];
experimentDescription.setup.vr.up = [0 0 -1];

m = 3.5;
experimentDescription.setup.vr.frustum.left = -m;
experimentDescription.setup.vr.frustum.right = m;
experimentDescription.setup.vr.frustum.bottom = -m;
experimentDescription.setup.vr.frustum.top = m;
experimentDescription.setup.vr.frustum.nearVal = 2;
experimentDescription.setup.vr.frustum.farVal = 500;

n=1;
% Run a calibration trial
experimentDescription.trial{n}.stimulus.showText.text = 'Calibration';
experimentDescription.trial{n}.recordingTime = 0;
experimentDescription.trial{n}.recording = 0;
experimentDescription.trial{n}.starttrial = 'keyboard';

n = n+1;
experimentDescription.trial{n}.stimulus.vr.calibrate.translatedelta = 0.1;
experimentDescription.trial{n}.stimulus.vr.calibrate.scaledelta = 0.05;
experimentDescription.trial{n}.stimulus.vr.calibrate.rotatedelta = 0.5;
experimentDescription.trial{n}.recording = 0; % we don't record the calibration
experimentDescription.trial{n}.recordingTime = inf;
experimentDescription.trial{n}.stimulus.vr.showFlipped = showFlipped;
experimentDescription.trial{n}.starttrial = 'dontWait';
experimentDescription.trial{n}.showPosition = 1; % show the hand on the screen

% These trials have no response, they are just for recording some movement.
% Start each trial by pressing the space bar
starttrial = 'keyboard';
response = 'dummy';

for k=1:5
    n = n+1;
    experimentDescription.trial{n}.stimulus.vr.showFlipped = showFlipped;
    experimentDescription.trial{n}.starttrial = starttrial;
    experimentDescription.trial{n}.targetType = response;
    experimentDescription.trial{n}.recordingTime = 5;
    experimentDescription.trial{n}.filename = ['file' num2str(k)];
    experimentDescription.trial{n}.showPosition = 1; % show the hand on the screen
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);



