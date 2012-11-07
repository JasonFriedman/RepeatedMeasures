% KEYBOARDSERVER - create a keyboard server to listen for connections and sample
% the keyboard card. Currently just returns RT / key pressed
%
% d = keyboardserver(port,maxsamplerate,debug)
%
% The keyboardserver will sample as fast as possible, so specify in
% maxsamplerate the maximum it will do (to avoid buffer overflows)
%
% e.g.
% d = keyboardserver(3002,6000);
% listen(d);

function d = keyboardserver(port,samplerate,debug)

d.waitEachCycle = [];
d.codes = [];

if nargin<5 || isempty(debug)
    debug = 0;
end

% Make a call to kbCheck so that the mex file will be loaded
[keyIsDown, secs, keyCode] = KbCheck([]);

d.codes = messagecodes;

d = class(d,'keyboardserver',socketserver(port,samplerate,debug));
