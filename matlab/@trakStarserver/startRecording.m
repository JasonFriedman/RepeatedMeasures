% STARTRECORDING - start recording with the trakStar
% (i.e., put it into continuous mode)
% 
% This is done by requesting a synchronous record

function ts = startRecording(ts)

getsample(ts,ts.numsensors);
