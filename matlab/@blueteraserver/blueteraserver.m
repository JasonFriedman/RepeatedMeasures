% BLUETERASERVER - create a bluetera server to listen for connections and sample from the bluetera
%
% r = blueteraserver(port,numsensors,debug)
%
% e.g.
% r = blueteraserver(3027,1,1);
% listen(r);

function r = blueteraserver(port,numsensors,debug)

r.addresses = {}; % This will be filled in by the client

if nargin<2 || isempty(numsensors)
    numsensors = 1;
end

r.numsensors = numsensors;

samplerate = 120;

r.codes = messagecodes;

if nargin<3 || isempty(debug)
    debug = 0;
end

r = class(r,'blueteraserver',socketserver(port,samplerate,debug));

blueTeraMex(0);