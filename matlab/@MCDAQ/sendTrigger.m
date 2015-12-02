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
if t.in_or_out==4 % digital out
    calllib('mccFuncLib','cbDOut',t.boardNum,t.channels,DataValue);
elseif t.in_or_out==5 % analog in + digital out
    %fprintf('Sending trigger %d on channel %d',DataValue,t.channels{2});
    MCDAQMex(3,t.boardNum,t.channels{2},DataValue);
else
    error('Can''t send trigger when DAQ card is set up for input');
end
