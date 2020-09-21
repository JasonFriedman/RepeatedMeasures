% STOPRECORDING - stop recording with the GoPro

function gs = stopRecording(gs)

% Only stop if it has started 
if gs.recording
    gopro('Stop');
    fprintf('Stopped recording with Gopro\n');
end

