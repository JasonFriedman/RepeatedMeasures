% POSTTRIAL - do anything that needs to be done post-trial

function [thistrial,experimentdata] = postTrial(s,dataSummary,thistrial,experimentdata,e)

devices = get(e,'devices');

if isfield(devices,'ATIforcesensors')
    return;
end

forcedata = dataSummary.toSave(:,2:end-1);

meanforcedata = mean(forcedata);

codes = messagecodes;
devices = get(e,'devices');


m.command = codes.FORCESENSORS_getParameters;
m.parameters = [];

sendmessage(devices.forcesensors,m,'getParameters');

[parameters,success] = receivemessage(devices.forcesensors);

if s.calibrationType==1
    experimentdata.forcesensorsOffsets(s.calibrationSensor) = meanforcedata(s.calibrationSensor);
    % Send the force offsets to the server (first get the old ones, then replace the offsets)
    
    parameters(1,s.calibrationSensor) = experimentdata.forcesensorsOffsets(s.calibrationSensor);
    % restore the old gain
    parameters(2,s.calibrationSensor) = thistrial.initialparameters(2,s.calibrationSensor);
    fprintf('Zerored sensors %d\n',s.calibrationSensor);
    
    m.command = codes.FORCESENSORS_setParameters;
    m.parameters = parameters;
    sendmessage(devices.forcesensors,m,'setParameters');
elseif s.calibrationType==2
    if ~isfield(experimentdata,'forcesensorsCalibrationWeights') || numel(experimentdata.forcesensorsCalibrationWeights)<s.calibrationSensor
        experimentdata.forcesensorsCalibrationWeights{s.calibrationSensor} = [];
        experimentdata.forcesensorsCalibrationVoltages{s.calibrationSensor} = [];
    end
    experimentdata.forcesensorsCalibrationWeights{s.calibrationSensor} = [experimentdata.forcesensorsCalibrationWeights{s.calibrationSensor} s.calibrationWeight];
    experimentdata.forcesensorsCalibrationVoltages{s.calibrationSensor} = [experimentdata.forcesensorsCalibrationVoltages{s.calibrationSensor} meanforcedata(s.calibrationSensor)];
    if numel(experimentdata.forcesensorsCalibrationWeights{s.calibrationSensor})>1
        % Calculate the gain (the offset is already removed by the server)
        thisgain = regress(experimentdata.forcesensorsCalibrationWeights{s.calibrationSensor}'*9.8,experimentdata.forcesensorsCalibrationVoltages{s.calibrationSensor}');
        experimentdata.forcesensorsGains(s.calibrationSensor) = thisgain;
                
        parameters(2,s.calibrationSensor) = thisgain;
        
        m.command = codes.FORCESENSORS_setParameters;
        m.parameters = parameters;
        sendmessage(devices.forcesensors,m,'setParameters');
    end
else
    error('Calibrationtype must be 1 or 2');
end