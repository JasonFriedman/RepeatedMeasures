% PARALLELPORT - handle communications with a parallel port (for sending triggers)
function p = parallelport(portname,debug)

p.portname = portname;
p.DIO = [];

if nargin<3 || isempty(debug)
    debug = 0;
end

p.debug = debug;

p.DIO = digitalio('parallel','LPT1');
hline = addline(dio, 0:7, 'Out');

p = class(p,'parallelport');