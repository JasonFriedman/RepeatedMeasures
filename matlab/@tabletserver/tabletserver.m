% TABLETSERVER - create a tablet server to listen for connections and sample
% the graphics tablet.
%
% d = tabletserver(port,maxsamplerate,debug)
%
% The tabletserver will sample as fast as possible, so specify in
% maxsamplerate the maximum it will do (to avoid buffer overflows)
%
% e.g.
% d = tabletserver(3009,150,43600,32799);
% listen(d);

function d = tabletserver(port,samplerate,debug)

if nargin<3 || isempty(debug)
    debug = 0;
end

d.codes = messagecodes;

d = class(d,'tabletserver',socketserver(port,samplerate,debug));