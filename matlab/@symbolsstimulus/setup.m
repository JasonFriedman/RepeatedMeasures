% SETUP - Prepare a "symbols" trial
% Do not call directly, will be called by runexperiment

function thistrial = setup(s,e,thistrial,experimentdata)

endtiming = s.stimuli(:,3);
starttiming = s.stimuli(:,2);

for k=1:numel(starttiming)
    for m=starttiming(k):endtiming(k)
        if s.stimuli(k,1)==0
            thistrial.stimuli_to_present{m} = '';
        else
            thistrial.stimuli_to_present{m} = experimentdata.symbols{s.stimuli(k,1)};
        end
    end
end

thistrial.stimuliFrames = round((thistrial.recordingTime - thistrial.waitTimeBefore)*experimentdata.screenInfo.monRefresh);


