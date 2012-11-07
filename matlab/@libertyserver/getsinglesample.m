% GETSINGLESAMPLE - get a single sample of data
% [data,framenumber] = getsinglesample(k,nummarkers,recordOrientation)
%
% This is usually used for testing, in general, continous mode
% is used during the experiment
%
% It should produce a 1xN array of data

function [data,framenumber] = getsinglesample(l,nummarkers)
framenumber = -1;
%fprintf('There are %d markers\n',nummarkers);
IOPort('Write',l.s,'P');
% 8 byte header, 12 bytes of data (32-bits each) + 4 bytes for frame
% counter (32-bit unsigned integer), PER MARKER
if l.recordOrientation
    bytesexpected = nummarkers * (8 + 12 + 12 + 4);
    datalength = 6;
else
    bytesexpected = nummarkers * (8 + 12 + 4);
    datalength = 3;
end
bytesavailable = IOPort('BytesAvailable',l.s);
while(bytesavailable < bytesexpected)
    pause(0.000001);
    bytesavailable = IOPort('BytesAvailable',l.s);
end
if bytesavailable~= bytesexpected
    error(['There are the wrong number of bytes available - ' ...
        num2str(bytesavailable) ' rather than ' num2str(bytesexpected)]);
end
for k=1:nummarkers
    % read the header (and ignore it)
    header = IOPort('Read',l.s,1,8);
    if ~all(header(1:2)=='LY')
        fprintf('Header does not start with LY in getsinglesample, rather');
        header
    end
    data(1,(k-1)*datalength+1:k*datalength) = convertBinaryToDouble(IOPort('Read',l.s,1,datalength*4));
    % only keep the last framenumber
    %        framenumber = typecast(IOPort('Read',l.s,1,4),'uint32');
    framenumber = [1 2^8 2^16 2^32]*IOPort('Read',l.s,1,4)';
end
data = [framenumber data GetSecs];



