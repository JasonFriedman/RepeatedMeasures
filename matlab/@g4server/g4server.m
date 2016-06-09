% G4SERVER - create a g4 server to listen for connections and sample from the g4
%
% g = g4server(port,numsensors,configurationFilePath,debug)
%
% e.g.
% g = g4server(3025,1,'c:\configfile.g4c');
% listen(g);

function g = g4server(port,numsensors,configurationFilePath,debug)

g.numsensors = [];
g.s = [];
g.sampleContinuously = 1; % whether to record continuously (faster but may introduce lag) or each time request a sample
g.samplingContinuously = 0; % used to know whether continous sampling has been turned on yet

samplerate = 120;

g.codes = messagecodes;

if nargin<2 || isempty(numsensors)
    g.numsensors = 1;
else
    g.numsensors = numsensors;
end

if nargin<3 || isempty(configurationFilePath)
    configurationFilePath = 'c:\configfile.g4c';
end

if nargin<4 || isempty(debug)
    debug = 0;
end

g = class(g,'g4server',socketserver(port,samplerate,debug));

G4Mex(0,configurationFilePath);