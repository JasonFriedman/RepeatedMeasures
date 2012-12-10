% MCTRIGGER - setup triggering or input with an MC DAQ card
%
% t = MCtrigger(dllpath,in_or_out)
% dllpath is the path to the file cbw32.dll
% in_or_out  = 1 -> output (default)
%            = 2 -> input

function t = MCtrigger(dllpath,in_or_out)

if nargin<2 || isempty(in_or_out)
    in_or_out = 1;
end

fprintf('MC Mode = %d (1=output, 2=input)\n',in_or_out);

% relevant constants (taken from cbw.h)
PRINTALL = 3;
DONTSTOP = 0;
DIGITALOUT = 1;
DIGITALIN = 2;
FIRSTPORTA = 10;
FIRSTPORTB = 11;

t.boardNum = [];
t.bitNums = [];
t.memoryPtr = [];

t.boardNum = 0;
t.DataValue = 3; % i.e., bit 0 and 1

% Load the dll, if it is not already loaded
if ~libisloaded('mccFuncLib')
    addpath(dllpath);
    loadlibrary('cbw32.dll','cbw.h','alias','mccFuncLib');
end

% Must be first call to UL
result = calllib('mccFuncLib','cbDeclareRevision',6.23);
% Print errors to a window (otherwise it silently fails!)
calllib('mccFuncLib','cbErrHandling',PRINTALL,DONTSTOP);
% Setup the port
if in_or_out == DIGITALOUT % 1
    ptr = calllib('mccFuncLib','cbDConfigPort',t.boardNum,FIRSTPORTA,DIGITALOUT);
else % DIGITALIN %2
    ptr = calllib('mccFuncLib','cbDConfigPort',t.boardNum,FIRSTPORTB,DIGITALIN);
    % Also allocate some memory
    t.memoryPtr = calllib('mccFuncLib','cbWinBufAlloc',2000*3+1000); % Allocate 3 seconds @ 2000 Hz + spare 1000
end

t = class(t,'MCtrigger');
