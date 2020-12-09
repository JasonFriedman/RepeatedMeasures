% SETUP - Prepare a trial. This is any preparation that needs to be done at the start of a trial.
% Do not call directly, this will be called by runexperiment

function thistrial = setup(s,e,thistrial,experimentdata)

thistrial.stimuliFrames = round((thistrial.recordingTime - thistrial.waitTimeBefore)*experimentdata.screenInfo.monRefresh);

devices = get(e,'devices');
if ~isfield(devices,'forcesensors') && ~isfield(devices,'ATIforcesensors')
    error('calibrateForceSensors only works when recording from force sensors');
end

if isfield(devices,'ATIforcesensors')
    return;
end

codes = messagecodes;

% We tell the server to record in V for the calibration (for the relevant sensors)

m.command = codes.FORCESENSORS_getParameters;
m.parameters = [];

sendmessage(devices.forcesensors,m,'getParameters');

[parameters,success] = receivemessage(devices.forcesensors);
thistrial.initialparameters = parameters;
if s.calibrationType==1
    % If zeroing, remove the previous offset
    parameters(1,s.calibrationSensor) = 0;
end
parameters(2,s.calibrationSensor) = 1;

m.command = codes.FORCESENSORS_setParameters;
m.parameters = parameters;

sendmessage(devices.forcesensors,m,'sendParameters');