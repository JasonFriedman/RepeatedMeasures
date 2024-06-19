% RUNNIDAQSERVER - run an arduino server for digital input/output on port 3010 in another matlab process
%
function runNIDAQserver(inputdevice,inputchannels,outputdevice,outputchannels)

if nargin<1 || isempty(inputdevice)
    inputdevice = '';
end

if nargin<2 || isempty(inputchannels)
    inputchannels = '';
end

if nargin<3 || isempty(outputdevice)
    outputdevice = '';
end

if nargin<4 || isempty(outputchannels)
    outputchannels = '';
end

if isempty(inputdevice) && isempty(outputdevice)
    error('There are no input or output defined!');
end

debug = 1;

runstring = sprintf('matlab -nojvm -r "d = NIDAQserver(3011,500,''%s'',''%s'',''%s'',''%s'',%d);listen(d)" &',...
        inputdevice,inputchannels,outputdevice,outputchannels,debug);

runstring

system(runstring);