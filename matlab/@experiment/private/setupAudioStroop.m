% setupAudioStroop - set up audio stroop for this trial
function thistrial = setupAudioStroop(thistrial,experimentdata)

count = 1;
% states:
% 0 = waiting for next audioStroop event
% 1 = beeping
% 2 = finished for this trial
thistrial.audioStroop.state = 0; % waiting for next audio stroop event
thistrial.audioStroop.nextaudioStrooponset(count) = thistrial.audioStroop.starttime;
thistrial.audioStroop.numStimuli = numel(thistrial.audioStroop.numbers);
if ~any(thistrial.audioStroop.type==[1 2])
    error('audioStroop type must be 1 or 2');
end