% GETMAXXY - get the maximum xy values from the first device that will give one
% Will return [NaN NaN] if no devices can give max x y data
% This is useful for tablet / mice
%
% [maxx,maxy] = getmaxxy(e)

function [maxx,maxy] = getmaxxy(e)

maxx = NaN;
maxy = NaN;

devicelist = fields(e.devices);
for k=1:length(devicelist)
    [maxx,maxy] = getmaxxy(e.devices.(devicelist{k}));
    if ~isnan(maxx)
        return;
    end
end
