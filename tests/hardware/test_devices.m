% TEST_DEVICES - smoke test of real devices (run with runAllTests('hardware'))
%
% For every device in rmtestHardwareConfig: connect to its server, record for 2 seconds,
% and check that samples arrive and that a data file with event markers is written.
% Nothing is simulated here: the device servers must be running. A device whose server
% cannot be reached is skipped.
function cases = test_devices
cases = [];
devices = rmtestHardwareConfig;
for k=1:numel(devices)
    d = devices{k};
    cases = rmtestCase(cases,['record 2 s from ' d.name],@(info) recordFromDevice(info,d));
end

function recordFromDevice(info,d) %#ok<INUSL>
% parameters are strings in a protocol file
p = d.parameters;
f = fieldnames(p);
for k=1:numel(f)
    if isnumeric(p.(f{k}))
        p.(f{k}) = num2str(p.(f{k}));
    end
end
resultDir = tempname;
mkdir(resultDir);
logger = logfilegeneratorInDir(resultDir);
try
    client = feval([d.name 'client'],p,logger,0);
catch err
    if ~isempty(strfind(err.message,'Could not connect')) %#ok<STREMP>
        rmtestSkip(sprintf('no %s server on %s:%s',d.name,p.server,p.port));
    end
    rethrow(err);
end
codes = messagecodes;
setupdevice(client);
client = setupRecording(client,[resultDir '/hardwaretest'],4,[]);
startRecording(client,'hardwaretest',4);
markEvent(client,codes.firstFrame);
nSamples = 0;
tstart = GetSecs;
while GetSecs - tstart < 2
    s = getsample(client);
    if ~isempty(s)
        nSamples = nSamples + 1;
    end
    WaitSecs(0.01);
end
stopRecording(client);
summary = getDataSummary(client); %#ok<NASGU>
saveFile(client);
closedevice(client);
close(client);
rmtestAssert(nSamples>10,'Only %d samples were received from %s in 2 s',nSamples,d.name);
files = dir([resultDir '/' d.prefix 'hardwaretest.csv']);
rmtestAssert(numel(files)==1,'The server did not write %shardwaretest.csv (check the prefix in rmtestHardwareConfig)',d.prefix);
data = load([resultDir '/' files(1).name]);
rmtestAssert(~isempty(data),'The data file of %s is empty',d.name);
rmtestAssert(any(data(:,end)==codes.firstFrame),'The event marker is missing from the data file of %s',d.name);

function l = logfilegeneratorInDir(resultDir)
% the clients write to the log of the "experiment" they belong to
oldDir = pwd;
cd(resultDir);
l = logfilegenerator;
cd(oldDir);
