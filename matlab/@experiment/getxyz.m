% GETXYZ - get an XYZ sample from the first device that will give one
% Will return [NaN NaN NaN] if no devices can give xyz data
%
% getxyz(e)

function xyz = getxyz(e)

devicelist = fields(e.devices);
for k=1:length(devicelist)
    xyz = getxyz(e.devices.(devicelist{k}));
    if ~isnan(xyz(1))
        return;
    end
end
