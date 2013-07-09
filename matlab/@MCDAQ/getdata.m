% GETDATA - used for reading data from the DAQ card

function result = getdata(t)


if t.in_or_out==2 % digital in
    [r,result] = calllib('mccFuncLib','cbDIn',t.boardNum,t.channels,0);
else
    result = MCDAQMex(2,t.boardNum,t.channels(1),t.channels(2),t.range);
end

