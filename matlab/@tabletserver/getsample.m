% GETSAMPLE - get the latest sample of data
% [data,framenumber] = getsample(k,nummarkers)
%
% It should produce a 1xN array of data

function [data,framenumber] = getsample(k,nummarkers)

pkt = WinTabMex(5);

if isempty(pkt)
    data = [NaN NaN NaN NaN NaN GetSecs];
    framenumber = NaN;
else
    % x y z position, the pressure, and the time
    framenumber = pkt(6);
    data = [pkt(1:3)' pkt(9) framenumber GetSecs];
    
end
