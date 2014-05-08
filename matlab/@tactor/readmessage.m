% READMESSAGE - read a message from the tactor
% result = readmessage(t)

function result = readmessage(t)

if t.connectionType==1
    result = IOPort('Read',t.s);
elseif t.connectionType==2
    result = [];
    for k=1:t.s.BytesAvailable
        result(k) = fread(t.s,1);
    end
end