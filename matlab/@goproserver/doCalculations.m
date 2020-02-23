% DOCALCULATIONS - do some calculations on the data, which can be requested from the client
%
function returnValue = doCalculations(s,data)

% Get the filename of the recorded data
pause(3);
returnValue.filename = readmedia(1);
fprintf('Last file was saved with name %s\n',returnValue.filename);


