% STARTRECORDING - start recording with the liberty
% (i.e., put it into continuous mode)

function ls = startRecording(ls)

if ls.sampleContinuously
    if ls.samplingContinuously
        if isdebug(ls)
            fprintf('Already sampling continuously so not starting again\n');
        end
    else
        if usingUSB(ls)
            LibertyMex(2);
        else
            IOPort('Write',ls.s,['C' char(13)]);
            ls.samplingContinuously = 1;
            if isdebug(ls)
                fprintf('Started recording continuously\n');
            end
        end
    end
end
