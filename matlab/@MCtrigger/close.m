% CLOSE - close the MC library (unload the dll)
%
% close(t)

function close(t)

unloadlibrary('mccFuncLib');
