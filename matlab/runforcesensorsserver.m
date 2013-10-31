% RUNFORCESENSORSSERVER - run a force sensors server on port 3016 in another matlab process
% The sensors are specificied on channels 0 to 4, with range "4" (-1V to +1V, see cbw.h for definitions)
function runforcesensorsserver(parameters,numsensors,firstsensor,sampleContinuously)

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

% for range, 4 = +- 1V, 0 = +- 5V
system(['matlab -nojvm -r "d = forcesensorsserver(3016,6000,[' num2str(firstsensor) ' ' num2str(firstsensor+numsensors-1) '],0,' parameters ','  num2str(sampleContinuously) ',1);listen(d)" &']);

