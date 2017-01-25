% REDAMBERSERVER - create a red amber server to listen for connections and sample from the red amber
%
% r = redamberserver(port,numsensors,debug)
%
% e.g.
% r = redamberserver(3026,1,1);
% listen(r);

function r = redamberserver(port,numsensors,debug)

r.addresses = {}; % This will be filled in by the client

if nargin<2 || isempty(numsensors)
    numsensors = 1;
end

r.numsensors = numsensors;

samplerate = 60;

r.codes = messagecodes;

if nargin<3 || isempty(debug)
    debug = 0;
end

r = class(r,'redamberserver',socketserver(port,samplerate,debug));

redamberMex(0);