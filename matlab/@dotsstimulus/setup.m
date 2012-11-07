% SETUP - Prepare a "dots" trial
% Do not call directly, will be called by runexperiment

function thistrial = setup(s,e,thistrial,experimentdata)

thistrial.dotArray = load(['stimuli/' s.dotsFilename]);
%flip the dotArray (because screen coordinates are
%opposite to optotrak coordinates
if s.flip(1)
    thistrial.dotArray(:,1)=1-thistrial.dotArray(:,1);
end
if s.flip(2)
    thistrial.dotArray(:,2)=1-thistrial.dotArray(:,2);
end
% rescale to the size of the screen
thistrial.dotArray(:,1) = thistrial.dotArray(:,1) * experimentdata.screenInfo.screenRect(3);
thistrial.dotArray(:,2) = thistrial.dotArray(:,2) * experimentdata.screenInfo.screenRect(4);

thistrial.stimuliFrames = length(thistrial.dotArray)* 4;
