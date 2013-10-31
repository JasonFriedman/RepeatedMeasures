function idle(s)
% IDLE - what to do when not sampling (default is nothing)

% get a sample but ignore it
if s.sampleContinuously
    getsample(s,1);
end