% HASSTARTED - This function should check if the necessary condition has been fulfilled to start the trial
% This should not be run directly, it is called by runexperiment.m
% This method should be overloaded by a child class to wait for anything
% meaningful (this version does not wait for anything)


started = 1;
[keyIsDown, secs, keyCode ] = KbCheck(-1);
