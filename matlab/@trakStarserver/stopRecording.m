% STOPRECORDING - stop recording with the trakStar
% (i.e., take it out of continuous mode)
%
% This is done by calling some other command


function ts = stopRecording(ts)

handleError(ts,calllib(ts.libstring, 'GetSensorStatus', 0));

% Getting an asynchronous sample ensures the buffer is cleared (otherwise
% next time getsample is called, old data will be returned)

[data,framenumber] = getsinglesample(ts,ts.numsensors);
