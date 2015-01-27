% CHARACTERSERVER - create a server to listen for characters sent over a socket connection
%
% This is designed for use with the Android app (sending triggers over a
% socket via the USB cable)
%
% cs = characterserver(port,maxnumsamples,filename,debug)
%
% e.g. 
% cs = characterserver(3033,1000,'tmpfile1.csv',1);
% listen(cs);

function cs = characterserver(port,maxnumsamples,filename,debug)

if isnumeric(filename)
    filename = sprintf('file%d.csv',filename);
end

if nargin<3 || isempty(debug)
    debug = 0;
end

cs.filename = filename;

cs = class(cs,'characterserver',socketserver(port,maxnumsamples,debug));
