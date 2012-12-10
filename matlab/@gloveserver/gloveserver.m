% GLOVESERVER - create a glove server to listen for connections and sample the data. 
%
% cgs = gloveserver(port,maxsamplerate,debug)
%
% e.g.
% cgs = gloveserver(3011,150,1);
% listen(d);

function cgs = gloveserver(port,samplerate,debug)

if nargin<3 || isempty(debug)
    debug = 0;
end

cgs.isConnected = 0;
cgs.codes = messagecodes;
cgs.getRawData = 0; % Whether to use raw data rather than calibrated data

cgs = class(cgs,'gloveserver',socketserver(port,samplerate,debug));
