% RUNATIFORCESENSORSSERVER - run an ATI force sensors server on port 3011 in another matlab process
%
% runATIforcesensorsserver(numsensors,samplerate,IPaddress)
%
% channels = channels on the wireless FT to use (default = 3)
% samplerate = sample rate (default =200), in Hz
% IPaddress - IP address of hte wireless ATI sensors

function runATIforcesensorsserver(channels,samplerate,IPaddress)

if nargin<1 || isempty(channels)
    channels = 3;
end

if nargin<2 || isempty(samplerate)
    samplerate = 200;
end

% port,samplerate,channels,IPaddress

ch = '[';
for k=1:numel(channels)
    if k>1
        ch = [ch ','];
    end
    ch = [ch num2str(channels(k))];
end
ch = [ch ']'];

runstring = sprintf('matlab -nodesktop -r "d = ATIforcesensorsserver(3011,%d,%s,''%s'');listen(d)" &',...
        samplerate,ch,IPaddress);

runstring
system(runstring);

