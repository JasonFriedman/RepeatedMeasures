% HASSTARTED - determine whether the trial has started
% Do not call directly, will be called by runexperiment

function [started,keyCode] = hasStarted(k,e,experimentdata,thistrial)

started = 0;

% Wait for keyboard input to start event
[keyisdown,secs, keyCode ] = KbCheck;
if keyisdown && (keyCode(k.keytopress) || keyCode(k.Q))
    %writetolog(e,sprintf('In keyboardstart, pressed key %d',find(keyCode)));
    started = 1;
end
