% READACK - read the ACK message, and display it (if in debug mode)
%
% readACK(t)

function readACK(t)

message = parseACK(readmessage(t));

if t.debug
    fprintf('%s\n',message);
end

