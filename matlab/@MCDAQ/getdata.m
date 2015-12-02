% GETDATA - used for reading data from the DAQ card

function result = getdata(t)


if t.in_or_out==2 % digital in
    [r,result] = calllib('mccFuncLib','cbDIn',t.boardNum,t.channels,0);
elseif t.in_or_out==4 % analog in
    result = MCDAQMex(2,t.boardNum,t.channels(1),t.channels(2),t.range);
elseif t.in_or_out==5
    result = MCDAQMex(2,t.boardNum,t.channels{1}(1),t.channels{1}(2),t.range);
else
    error('Can only get data when in_or_out is 2,4 or 5');
end

