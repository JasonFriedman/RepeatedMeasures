% MOUSESERVER - create a mouse server to listen for connections and sample
% the mouse. Currently just returns RT / key pressed
%
% d = mouseserver(port,maxsamplerate,debug)
%
% The mouseserver will sample as fast as possible, so specify in
% maxsamplerate the maximum it will do (to avoid buffer overflows)
%
% e.g.
% d = mouseserver(3002,6000);
% listen(d);

function d = mouseserver(port,samplerate,debug)

if nargin<3 || isempty(debug)
    debug = 0;
end

d.codes = messagecodes;

d = class(d,'mouseserver',socketserver(port,samplerate,debug));
