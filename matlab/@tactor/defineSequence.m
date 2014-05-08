% DEFINESEQUENCE - define a sequence (to play back later)
% This will not play the sequence, only define it. This is slow so it is
% better to do this before the sequence is needed
%
% defineSequence(sequenceNumber,commands,parameters)
% commands should be a 1xN array
% parameters should be a 1xN cell array
%
% commands can be 1 = turn on specified tactors
%                 2 = wait (for a specified number of ms)
%                 3 = turn off all tactors
%                 4 = set signal source (sin1 or sin2 or sin1+sin2)
%                 5 = vibrate for set time
% 
% parameters should have the parameters for these commands
% for 1, an array with the tactors to turn on
% for 2, the duration (in ms)
% for 3, empty
% for 4, two values, one for tactors 1-4, one for tactors 5-8, with values 0 = none, 1 = sin1, 2 = sin2, 3 = sin1+sin2
% for 5, an array with the sensors numbers, with the last number the duration in ms (e.g. sensors 1+2 for 100 ms is [1 2 100])
%
%
% e.g. for 3 on-off vibrations for sensors 1 and 3
% 
% commands =    [1    2   3  2   1     2   3  2   1     2   3];
% parameters = {[1 2],250,[],250,[1 2],250,[],250,[1 2],250,[]};
% defineSequence(t,1,commands,parameters);
%

function defineSequence(t,sequenceNumber,commands,parameters)

if numel(commands) ~= numel(parameters)
    error('Number of commands needs to be equal to number of parameters');
end

seqdata = [];
for k=1:numel(commands)
    if commands(k)==1
        seqdata = [seqdata setTactorsCommand(parameters{k})];
    elseif commands(k)==2
        seqdata = [seqdata seqWaitCommand(parameters{k})];
    elseif commands(k)==3
        seqdata = [seqdata turnAllOffCommand];
    elseif commands(k)==4
        seqdata = [seqdata setSigSrcCommand(parameters{k}(1),parameters{k}(2))];
    elseif commands(k)==5
        seqdata = [seqdata vibrateTactorCommand(parameters{k}(1:end-1),parameters{k}(end))];
    else
        error('Unknown command (must be 1,2 or 3)');
    end
end
sendmessage(t,seqStartCommand(sequenceNumber,numel(seqdata)));
pause(0.5);
fprintf('seqStartCommand:');
readACK(t);
sequenceData = seqDataCommand(seqdata);
for k=1:numel(sequenceData)
    sendmessage(t,sequenceData{k});
    pause(2.0);
    fprintf('SequenceData:');
    readACK(t);
end
pause(0.5);
sendmessage(t,seqEndCommand(seqdata));
pause(0.5);
readACK(t);