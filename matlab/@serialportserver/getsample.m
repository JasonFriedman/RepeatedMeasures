% GETSAMPLE - get the latest sample of data
% [data,framenumber] = getsample(k,nummarkers)

function [data,framenumber] = getsample(sc,nummarkers)

sendmessage(sc.s,'s');
readdata = readmessage(sc.s,16);

if strcmp(sc.protocol,'Arduino')
    % The position information is in the form Plocation,timestamp
    if numel(readdata)==0 || readdata(1)~= 'P'
        data = [NaN NaN];
        framenumber = -1;
        % clear the buffer
        readdata = readmessage(sc.s);
    else
        chardata = char(readdata);
        % The data is in characters 2-5
        data = [str2double(chardata(2:5)) GetSecs];
        framenumber = str2double(chardata(7:14));
    end
else
    error('Unknown serial client protocol');
end