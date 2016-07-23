% GETSAMPLE - get the latest sample of data
% [data,framenumber] = getsample(k,nummarkers)

function [data,framenumber] = getsample(sc,numvalues)

sendmessage(sc.s,'s');
readdata = readmessage(sc.s,sc.numCharacters);

if strcmp(sc.protocol,'Arduino')
    % The position information is in the form Plocation,timestamp
    if numel(readdata)==0 || readdata(1)~= 'P'
        data = NaN * ones(1,numvalues);
        framenumber = -1;
        % clear the buffer
        readdata = readmessage(sc.s);
    else
        chardata = char(readdata);
        tmp = str2num(chardata(2:end)); % Use str2num because there is a comma separated list, skip the opening P
        data = [tmp(1:end-1) GetSecs];
        framenumber = data(end);
    end
else
    error('Unknown serial client protocol');
end