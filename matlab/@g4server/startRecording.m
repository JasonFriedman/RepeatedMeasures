% STARTRECORDING - start recording with the G4
% (i.e., put it into continuous mode)

function ls = startRecording(ls)

if ls.sampleContinuously
    if ls.samplingContinuously
        if isdebug(ls)
            fprintf('Already sampling continuously so not starting again\n');
        end
    else
        G4Mex(2);
    end
end
