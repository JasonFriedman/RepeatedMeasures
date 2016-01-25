% TRACKSTARSERVER - create a trakStar server to listen for connections and sample
% 
% For collecting data from an Ascension trakStar system
% ts = trakStarserver(port,samplerate,no_of_receivers,dllpath,debug)
%
% e.g. 
% ts = trakStarserver(3019,200,1,'D:\equipment\trakStar\MatlabDemo',1);
% listen(ts);
%

function ts = trakStarserver(port,samplerate,no_of_receivers,dllpath,debug)

ts.numsensors = no_of_receivers;
ts.codes = messagecodes;
ts.samplerate = samplerate;
ts.libstring = [];

if nargin<5 || isempty(debug)
    debug = 0;
end

addpath(dllpath);

ts = class(ts,'trakStarserver',socketserver(port,samplerate,debug));