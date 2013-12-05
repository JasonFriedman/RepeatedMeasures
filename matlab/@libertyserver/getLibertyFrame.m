function [data,framenumber,libertyMarkerNum] = getLibertyFrame(l,datalength)

header = IOPort('Read',l.s,1,8);
% If this is the carriage return, read two more bytes
if all(header(1:2)==[13 10]) && numel(header)==8
    header = [header(3:8) IOPort('Read',l.s,1,2)];
end
if ~all(header(1:2)=='LY')
    fprintf('Header does not start with LY, rather');
    header
    % In this case, we keep reading until we get the header
    done = 0;
    skipped = 0;
    while ~done
        nextchar = IOPort('Read',l.s,1,1);
        skipped = skipped + 1;
        if nextchar=='L'
            nextchar = IOPort('Read',l.s,1,1);
            if nextchar=='Y'
                % read 6 more characters
                rest_of_header = IOPort('Read',l.s,1,6);
                fprintf('Skipped %d characters\n',skipped);
                done = 1;
            end
        end
    end
end
libertyMarkerNum = header(3);
data = convertBinaryToDouble(IOPort('Read',l.s,1,datalength*4));
framenumber = [1 2^8 2^16 2^32]*IOPort('Read',l.s,1,4)';