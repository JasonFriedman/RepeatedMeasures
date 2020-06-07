% INITIALIZEDEVICE - set the properties for the gopro recording
% based on what was passed to goproserver

function gs = initializeDevice(gs)

gopro(gs.resolution);
fprintf('Set resolution to %s\n',gs.resolution);

gopro(gs.fps);
fprintf('Set fps to %s\n',gs.fps);

gopro(gs.view);
fprintf('Set view to %s\n',gs.view);



