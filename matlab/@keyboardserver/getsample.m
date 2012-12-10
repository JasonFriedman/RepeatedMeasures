% GETSAMPLE - get the latest sample of data
% [data,framenumber] = getsample(k,nummarkers)
%
% It should produce a 1xN array of data

function [data,framenumber] = getsample(k,nummarkers)

[keyIsDown, secs, keyCode] = KbCheck([]);

framenumber = secs;
if keyIsDown
    % we only want one keyCode
    data = find(keyCode);
    if length(data)>1
        data = data(1);
    end
else
    data = 0;
end
% Put the time in the first column
data = double([secs data]);

