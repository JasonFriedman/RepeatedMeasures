% SETSIGSRC - set the signal source (sin1 or sin2 or sin1+sin2)
%
% command = setSigSrcCommand(lownibble,highnibble)
%
% lownibble is for tactors 1-4
% highnibble is for tactor 5-8
%
% for each, 0: No Signal
%   		1: Signal from Primary sinewave generator
%	   	    2: Signal from Secondary sinewave generator
%		    3: Summed Signals from both sinewave generators

function setSigSrc(t,lownibble,highnibble)

command = setSigSrcCommand(lownibble,highnibble);

sendcommand(t,command);
pause(0.1);
readACK(t);