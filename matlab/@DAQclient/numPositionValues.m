% NUMPOSITIONVALUES - number of values used to calculate the position: one per channel
% (also used by forcesensorsclient, where each value is the force of one sensor)
function n = numPositionValues(dc)
if isempty(dc.numchannels)
    n = NaN;
else
    n = dc.numchannels;
end
