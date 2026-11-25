% MAKEBOUNCINGDOTFILE - make a file with a bouncing dot, 
% suitable as a dot stimuli for RepeatedMeasures

function makeBouncingDotFile(samplerate,numSeconds,filename)

numFrames = samplerate * numSeconds;

startPosition = [0.2 0.3];
startAngle = 15 * pi / 180; % 15 degrees
velocity = 0.1;

positions = makeBouncingDot(startPosition,startAngle,velocity,numFrames,0);

csvwrite(filename,positions);