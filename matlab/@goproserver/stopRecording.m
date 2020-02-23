% STOPRECORDING - stop recording with the GoPro

function gs = stopRecording(gs)

gopro('Stop');
fprintf('Stopped recording with Gopro\n');
