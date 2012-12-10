% DAQSERVER - create an DAQ server to listen for connections and sample
% the DAQ card. Currently just returns RT
%
% d = DAQserver(port,maxsamplerate,bits,dllpath,debug)
%
% The DAQserver will sample as fast as possible, so specify in
% maxsamplerate the maximum it will do (to avoid buffer overflows)
%
% e.g.
% d = DAQserver(3001,6000,1:3,'D:\ExpPC_Files\Jason\MatlabExperiments\cbw');
% listen(d);

function d = DAQserver(port,samplerate,bits,dllpath,debug)

if nargin<5 || isempty(debug)
    debug = 0;
end

d.codes = messagecodes;
d.bits = bits;
in_or_out = 2; % just input for now
d.t = MCtrigger(dllpath,in_or_out);

d = class(d,'DAQserver',socketserver(port,samplerate,debug));
