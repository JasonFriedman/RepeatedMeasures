% PARALLELPORT - handle communications with a parallel port (for sending triggers)
function p = parallelport(portaddress,debug)

p.portaddress = hex2dec(portaddress);

if nargin<2 || isempty(debug)
    debug = 0;
end

p.debug = debug;
p.lib = 'inpoutx64';
if ~libisloaded(p.lib)
    if ~exist('inpout32.h','file')
        error('The file inpout32.h must be in the current directory');
    end
    if ~exist([p.lib '.dll'],'file')
        error(['The file ' p.lib ' must be in the current directory']);
    end
    loadlibrary([p.lib '.dll'], 'inpout32.h');
end

% Set all to zero
clearTrigger = 0;
calllib(p.lib, 'Out32', p.portaddress, clearTrigger);
p = class(p,'parallelport');