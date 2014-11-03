% RUNFORCESENSORSSERVER - run a force sensors server on port 3016 in another matlab process
% The sensors are specificied on channels 0 to 4, with range "4" (-1V to +1V, see cbw.h for definitions)
%
% runforcesensorsserver(parameters,numsensors,firstsensor,sampleContinuously,numChannelsTotal)
%
function runforcesensorsserver(parameters,numsensors,firstsensor,sampleContinuously,numChannelsTotal)

if nargin<1 || isempty(parameters)
    parameters = '[0 0 0 0 0;1 1 1 1 1]'; % i.e. record the voltage
end

if nargin<2
    numsensors = 5;
end

if nargin<3
    firstsensor = 0;
end

if nargin<4
    sampleContinuously = 0;
end

if nargin<5
    numChannelsTotal = 8;
end

% for range, 4 = +- 1V, 0 = +- 5V
system(sprintf('matlab -nojvm -r "d = forcesensorsserver(3016,6000,[%d %d ],0, %s ,%d,%d,1);listen(d)" &',...
    firstsensor,firstsensor+numsensors-1,parameters,sampleContinuously,numChannelsTotal));

