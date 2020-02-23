% STARTRECORDING - start recording with the GoPro
% 
% It is not possible to specify the filename

function gs = startRecording(gs)

gopro('Trigger');
fprintf('Started recording with Gopro\n');