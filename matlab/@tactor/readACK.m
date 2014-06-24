% READACK - read the ACK message, and display it (if in debug mode)
%
% readACK(t)

function readACK(t,displayResult)

if nargin<2 || isempty(displayResult)
    displayResult = 0;
end

message = parseACK(readmessage(t));

if t.debug || displayResult
    fprintf('%s\n',message);
end

