% CALCULATELASTPOSITION - calculate the screen position, based on the recorded position and viewing parameters
% This is based on calculateLastPosition.m from @socketclient (modified to
% work on the recorded data, whole trial at once)

function lastsamples = calculateLastPosition(m,dataSummary,thistrial)

displayRangeX = m.displayRangeX;
displayRangeY = m.displayRangeY;

data = dataSummary.toSave(:,m.columnsToUse);
dims = size(data,2);
numpositions = size(displayRangeX,2) / (2*dims+1);
if numpositions ~= round(numpositions)
    error(['Size of displayRangeX is incorrect. It should have a width of num dots * (2*number of dimensions (' ...
        num2str(dims) ') + 1)' ...
        '(instead of ' num2str(size(displayRangeX,2)) ')']);
end

% Assume the samples are equally spaced in time (i.e. constant
% sampling rate)
recordingTime = thistrial.recordingTime;
thetimes = linspace(0,recordingTime,size(data,1));

for z=1:size(data,1) % number of samples recorded
    lastsample = data(z,:);
    thistime = thetimes(z);
    
    for p=1:numpositions
        lastposition(p,1) = m.offsetX(1,p);
        lastposition(p,2) = m.offsetY(1,p);
        offset = (p-1)*(2*dims+1);
        
        for n=1:dims
            if numel(displayRangeX)>0 && displayRangeX(1,offset+n*2) ~= displayRangeX(1,offset+n*2-1)
                lastposition(p,1) = lastposition(p,1) + (lastsample(n) - displayRangeX(1,offset+n*2-1)) ...
                    / (displayRangeX(1,offset+n*2) - displayRangeX(1,offset+n*2-1));
            end
            if numel(displayRangeY)>0 && displayRangeY(1,offset+n*2) ~= displayRangeY(1,offset+n*2-1)
                lastposition(p,2) = lastposition(p,2) + (lastsample(n) - displayRangeY(1,offset+n*2-1)) ...
                    / (displayRangeY(1,offset+n*2) - displayRangeY(1,offset+n*2-1));
            end
        end
        if numel(displayRangeX)>0
            lastposition(p,1) = lastposition(p,1) + displayRangeX(1,offset+2*dims+1) * thistime;
        end
        if numel(displayRangeY)>0
            lastposition(p,2) = lastposition(p,2) + displayRangeY(1,offset+2*dims+1) * thistime;
        end
    end
    lastsamples(:,z,:) = lastposition;
end