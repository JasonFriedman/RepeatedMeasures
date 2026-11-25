% MAKERANDOMLINESFILE - make a file with random lines, 
% suitable as a dot stimuli for RepeatedMeasures

function makeRandomLinesFile(samplerate,numSeconds,filename)

numFrames = samplerate * numSeconds;

velocity = 0.03;
numPerLine = 10;
positions = makeRandomLines(numFrames,numPerLine,velocity);

csvwrite(filename,positions);