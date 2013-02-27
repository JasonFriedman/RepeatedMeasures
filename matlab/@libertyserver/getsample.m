% GETSAMPLE - get the latest sample of data (when in continous mode)
% To get a sample when not running continuously, use getsinglesample
%
% [data,framenumber] = getsample(k,nummarkers)
%
% It should produce a 1xN array of data

function [data,framenumber] = getsample(l,nummarkers)

if ~l.sampleContinuously
    [data,framenumber] = getsinglesample(l,nummarkers);
    return;
end

if l.recordOrientation
    datalength = 6;
else
    datalength = 3;
end

if usingUSB(l)
    data = zeros(1,nummarkers*datalength+2);
    tmpdata = LibertyMex(3,nummarkers,datalength/3);
    if numel(tmpdata)>0
       data(1:end-1) = tmpdata;
    end
    framenumber = data(1);
    data(end) = GetSecs;
else
    data = zeros(1,nummarkers*datalength+2);
    bytesexpected = (nummarkers * datalength + 3) * 4;
    bytesavailable = IOPort('BytesAvailable',l.s);
    %fprintf('Bytes expected = %d, bytes available = %d\n',bytesexpected,bytesavailable);
    while(bytesavailable < bytesexpected)
        pause(0.000001);
        bytesavailable = IOPort('BytesAvailable',l.s);
    end
    
    for k=1:nummarkers
        [thisdata,framenumber,libertyMarkerNum] = getLibertyFrame(l,datalength);
        while libertyMarkerNum ~= k
            fprintf('Wrong marker: %d instead of %d\n',libertyMarkerNum,k);
            [thisdata,framenumber,libertyMarkerNum] = getLibertyFrame(l,datalength);
        end
        data(1,(k-1)*datalength+2:k*datalength+1) = thisdata;
    end
    
    if any(data(1:datalength)>1000) || any(data(1:datalength)<-1000)
        fprintf('Strange result so calling again\n');
        [data,framenumber] = getsample(l,nummarkers);
        fprintf('This time got (%.2f,%.2f,%.2f)\n',data(1),data(2),data(3));
    end
    
    data(1) = framenumber;
    data(end) = GetSecs;
end

