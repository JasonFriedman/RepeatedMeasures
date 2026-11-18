% REPEATROWSFORSENSORS - use a one-row displayRangeX / displayRangeY for every sensor
%
% sc = repeatRowsForSensors(sc,numsensors,valuesPerSensor)
%
% For devices with several sensors (e.g. Liberty, G4), a displayRangeX / displayRangeY
% with one row of 2*valuesPerSensor+1 columns (per dot) is repeated for each sensor, so
% that each row uses the values of its own sensor. This is done for each cell (trial).
% A single row that already covers all the sensors (2*numsensors*valuesPerSensor+1
% columns per dot) is left as it is.
function sc = repeatRowsForSensors(sc,numsensors,valuesPerSensor)
if numsensors<=1
    return;
end
names = {'displayRangeX','displayRangeY'};
for n=1:2
    ranges = sc.(names{n});
    for k=1:numel(ranges)
        r = ranges{k};
        if size(r,1)==1 && ~isempty(r) && mod(size(r,2),2*valuesPerSensor+1)==0
            ranges{k} = repmat(r,numsensors,1);
        end
    end
    sc.(names{n}) = ranges;
end
