% GETXYZ - get an XYZ sample from the first device that will give one
% Will return [NaN NaN NaN] if no devices can give xyz data
%
% getxyz(e)
% 
% If justfirst = 1, then only return the first sensor (default 0)

function xyz = getxyz(e)

devicelist = fields(e.devices);
for k=1:length(devicelist)
    xyz = getxyz(e.devices.(devicelist{k}));
    if ~isnan(xyz(1))
        return;
    end
end
