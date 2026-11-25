% RUNEXPERIMENTTABLETFIRST

result = inputdlg('Subject number');

subject = result{1};

generateProtocol(5,[],subject,3);

r3 = runTablet(subject);

% copyrectangles

generateProtocol(5,[],subject,4);

r2 = runCopyRectanglesLiberty(subject);

!taskkill /fi "Windowtitle eq MATLAB command window"

msgbox('Plug in the DAQ card');

generateDecisionProtocol(subject);
%generateDecisionProtocol(subject,1);

r4 = runDecision(subject);
%r4 = runDecision(subject,1);

!taskkill /fi "Windowtitle eq MATLAB command window"