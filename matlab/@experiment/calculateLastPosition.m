% CALCULATELASTPOSITION - calculate the last position from the first device that will give one
%
% [lastpositionVisual,thistrial] = calculateLastPosition(e,lastposition,thistrial,frame)

function [lastpositionVisual,thistrial] = calculateLastPosition(e,lastposition,thistrial,frame)

devicelist = fields(e.devices);
for k=1:length(devicelist)
    [lastpositionVisual,thistrial] = calculateLastPosition(e.devices.(devicelist{k}),lastposition,thistrial,frame);
    if ~isnan(lastpositionVisual(1))
        return;
    end
end
