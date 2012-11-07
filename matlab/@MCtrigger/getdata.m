% GETDATA - used for reading data from the DAQ card

function result = getdata(t)

FIRSTPORTA = 10;
FIRSTPORTB = 11;

[r,result] = calllib('mccFuncLib','cbDIn',t.boardNum,FIRSTPORTB,0);
% result has the data
