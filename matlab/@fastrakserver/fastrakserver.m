% FASTRAKSERVER - create a Fastrak server to listen for connections and sample
% the data. 
%
% fts = fastrakserver(port,samplerate,no_of_receivers, debug)
%
% e.g. 
% fts = fastrakserver(5,60,2,1);
% listen(fts);
%
% Update Rate
% One receiver 120 updates/second
% Two receivers 60 updates/second
% Three receivers 40 updates/second
% Four receivers 30 updates/second

function fts = fastrakserver(port,samplerate,no_of_receivers,debug)

if nargin<4 || isempty(debug)
    debug = 0;
end
fts.isConnected = 0;
fts.receivers = no_of_receivers;
fts.codes = messagecodes;

fts = class(fts,'fastrakserver',socketserver(port,samplerate,debug));
