% SENDTRIGGER - send a trigger
%
% Generally, you will need to set the trigger to high (1) then later
% back to low (0)
%
% When value is set to 1, a trigger is sent on all channels
% When value is set to 0, 0 is sent on all channels
%
% sendTrigger(t,value)
% sendTrigger(t,value,customDataValue)
%
% If customDataValue is set, these channels are sent 1 rather than the default

function sendTrigger(t,value,customDataValue)

FIRSTPORTA = 10;

if value==0
    DataValue=0;
else
    if nargin>2
        DataValue = customDataValue;
    else
        DataValue = t.DataValue;
    end
end

% Send all triggers at once
calllib('mccFuncLib','cbDOut',t.boardNum,FIRSTPORTA,DataValue);
