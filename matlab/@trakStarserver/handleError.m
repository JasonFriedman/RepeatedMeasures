% HANDLEERROR Handle errors (print the error message)
function  handleError(ts,temp)

while(temp ~= 0)
    tt = blanks(1024);
    pRecords = libpointer('cstring', tt);
    [temp, pRecords1] = calllib(ts.libstring, 'GetErrorText', int32(temp), pRecords , 1024, 1);
    fprintf('%s\n',pRecords1);
    %error('Error with trakStar (see message above)');
end
