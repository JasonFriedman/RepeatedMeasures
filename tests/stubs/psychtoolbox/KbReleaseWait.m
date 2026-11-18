% KBRELEASEWAIT - stub: advance the virtual clock until no key is pressed
function [secs,keyCode] = KbReleaseWait(varargin)
[keyIsDown,secs,keyCode] = KbCheck;
count = 0;
while keyIsDown && count < 1e6
    WaitSecs(0.001);
    [keyIsDown,secs,keyCode] = KbCheck;
    count = count + 1;
end
