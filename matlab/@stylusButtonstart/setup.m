% SETUP - Do any preparation needed for starting the trial
% Do not call directly, this will be called by runexperiment
% For stylus button, this tells the program to start sampling

function thistrial = setup(s,thistrial)

thistrial.sampleWhenNotRecording = 1;
% We pretend to record so that the setup
thistrial.recording = 1;
thistrial.filename = 'tablet_dummy';