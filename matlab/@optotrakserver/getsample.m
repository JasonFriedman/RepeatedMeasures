% GETSAMPLE - get the latest sample of data
% [data,framenumber] = getsample(o,nummarkers)
%
% It should produce a 1xN array of data

function [data,framenumber] = getsample(o,nummarkers)

% Get the latest 3D data
optodata = optotrak('DataGetLatest3D',nummarkers);

framenumber =  optodata.FrameNumber;
data(1,1) = framenumber;
for k=1:nummarkers
    data(1,(k-1)*3+2:(k-1)*3+4) = optodata.Markers{k};
end
if isdebug(o)
    %fprintf('Got a frame of data\n');
end
