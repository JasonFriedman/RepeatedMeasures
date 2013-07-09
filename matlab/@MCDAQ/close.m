% CLOSE - close the MC library (unload the dll when necessary)
%
% close(t)

function close(t)

if t.in_or_out<=2
    unloadlibrary('mccFuncLib');
end
