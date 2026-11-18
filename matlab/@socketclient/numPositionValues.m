% NUMPOSITIONVALUES - number of values used to calculate the position (showPosition = 3, 4, 5)
%
% n = numPositionValues(sc)
%
% The number of values the device passes to calculateLastPosition, which displayRangeX and
% displayRangeY must match (see checkShowPosition). Devices that show a position override
% this. NaN means unknown (no check is made).
function n = numPositionValues(sc) %#ok<INUSD>
n = NaN;
