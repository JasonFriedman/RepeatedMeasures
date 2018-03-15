% RUNDAQSERVER - run a DAQ server for digital input (RT) on port 3016 in another matlab process
function runDAQserver(sensors)

if nargin<1
    sensors = 1:3;
end

sensorsString = '[';
for k=1:numel(sensors)
    sensorsString = [sensorsString ' ' num2str(sensors(k))];
end
sensorsString = [sensorsString ']'];

sampletype = 4; % analog input

debug = 1;

range = 0; % for range, 4 = +- 1V, 0 = +- 5V

runstring = sprintf('matlab -nojvm -r "d = DAQserver(3016,6000,%s,'''',%d,%d,%d,%d);listen(d)" &',...
        sensorsString,sampletype,range,numel(sensors),debug);

runstring

system(runstring);