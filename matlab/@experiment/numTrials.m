% NUMTRIALS - returns the number of trials to be run
% 
% num = numTrials(e)

function num = numTrials(e)

num = length(e.protocol.trial);
