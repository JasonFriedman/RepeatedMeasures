% STOPRECORDING - stop recording with the G4
% (i.e., take it out of continuous mode)

function ls = stopRecording(ls)

if ls.sampleContinuously
    G4Mex(4);
else
    if isdebug(ls)
        fprintf('Not stopping continuously sampling because already stopped\n');
    end
end