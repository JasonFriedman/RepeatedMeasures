% CALIBRATEFORCESENSORSSTIMULUS - a stimulus for calibrating (zeroing, setting gain) for force sensors

function [v,params] = calibrateForceSensorsstimulus(inputParams,experimentdata)

params.name = {'calibrationType','calibrationSensor','calibrationWeight'};
params.type = {'number','matrix','number'};
params.description = {'1 = zero force sensors, 2 = calibrate with known weight','Sensors to calibrate','weight in kg (only applicable when calibrationType=1)'};
params.required = [1 1 0];
params.default = {1,1,0};
params.classdescription = 'Calibrate force sensors';
params.classname = 'calibrateForceSensorsstimulus';
params.parentclassname = 'stimulus';

if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

v = class(v,'calibrateForceSensorsstimulus',stimulus(parent));
