% READDATATOBUFFER

function readDataToBuffer(t)

error('This function does not work');
% It is not supported by the card we have
FIRSTPORTA = 10;
BACKGROUND = int32(1);

rate = 2000;
duration = 3;
therate = libpointer('int32Ptr',2000);

ChanArray = libpointer('int16Ptr',1);
ChanTypeArray = libpointer('int16Ptr',1);
GainArray = libpointer('int16Ptr',1);
ChannelCount = int32(1);
PreTrigCount = libpointer('int32Ptr',0);
TotalCount = libpointer('int32Ptr',1000);


% int cbDInScan(int BoardNum, int PortNum, long count, long *Rate, int MemHandle, int Options)
[x1,x2,x3,x4,x5,x6,x7,x8] = calllib('mccFuncLib','cbDaqInScan',...
    int32(t.boardNum),... %int32
    ChanArray,... %int16Ptr
    ChanTypeArray,... %int16Ptr
    GainArray,... %int16Ptr
    ChannelCount,... %int32
    therate,... %int32Ptr
    PreTrigCount,... %int32Ptr
    TotalCount,... %int32Ptr
    t.memoryPtr,... %voidPtr
    BACKGROUND); % int32

%    [r,result] = calllib('mccFuncLib','cbDInScan',t.boardNum,FIRSTPORTA,rate*duration,therate,t.memoryPtr,BACKGROUND);
% result has the data
