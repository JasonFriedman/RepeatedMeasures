% STOPRECORDING - stop recording with the liberty
% (i.e., take it out of continuous mode)

function ls = stopRecording(ls)

if ls.sampleContinuously
    if ls.samplingContinuously
        IOPort('Write',ls.s,['P' char(13)]);
        if isdebug(ls)
            fprintf('Stopped recording continuously\n');
        end
        
        % Clear anything on the port
        inBuffer = IOPort('Read',ls.s,1,IOPort('BytesAvailable',ls.s));
        ls.samplingContinuously = 0;
    else
        if isdebug(ls)
            fprintf('Not stopping continuosly sampling because already stopped\n');
        end
    end
end