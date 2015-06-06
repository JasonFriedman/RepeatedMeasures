 % SETUPTRACKERS Setup Ascension trakStar
%
% setupTrackers(ts)

function ts = initializeDevice(ts)

enuminfo = getEnums;

if strcmp(computer, 'PCWIN64')
    ts.libstring = 'ATC3DG64';
elseif strcmp(computer, 'PCWIN')
    ts.libstring = 'ATC3DG';
else
    error('TrakStar functionality is only supported for 32 and 64 bit Windows');
end

% Load the library
[notfound,warnings]=loadlibrary(ts.libstring, 'ATC3DG.h');

% Quit if it was not loaded successfully
if ~libisloaded(ts.libstring)
    error('Error in loading trakStar library / dll');
end

% Initialize the system
handleError(ts,calllib(ts.libstring, 'InitializeBIRDSystem'));

% Get the system configuration
configuration = libstruct('tagSYSTEM_CONFIGURATION'); 
configuration.agcMode = 0;
configurationPointer = libpointer('tagSYSTEM_CONFIGURATION', configuration);
handleError(ts,calllib(ts.libstring, 'GetBIRDSystemConfiguration', configurationPointer));

measurementRate = configuration.measurementRate;
numBoards       = configuration.numberBoards;
numSensorsMax   = configuration.numberSensors;
clear configuration configurationPointer;

% Go through the sensors and check they are actually there
attachedString = {'not attached','attached'};
numSensors = 0;
for sensor = 1:numSensorsMax
    sensorConfiguration = libstruct('tagSENSOR_CONFIGURATION'); 
    sensorConfiguration.type = 11;
    sensorConfigurationPointer = libpointer('tagSENSOR_CONFIGURATION', sensorConfiguration);
    handleError(ts,calllib(ts.libstring, 'GetSensorConfiguration', sensor-1, sensorConfigurationPointer));
    numSensors = numSensors + sensorConfiguration.attached;
    fprintf('Sensor %d is %s\n',sensor,attachedString{sensorConfiguration.attached+1});
end
clear sensorConfiguration sensorConfigurationPointer;

fprintf('There are %d sensors connected\n',numSensors);
if numSensors ~= ts.numsensors
    error('The number of receivers connected (%d) does not match the number expected (%d)',numSensors,ts.numsensors);
end

% Note: the size (the last parameter) depends on the type, 
% which can be found in the API documentation
% boolean = 4
% short int = 2
% double = 8

% Turn on the transmitter
handleError(ts,calllib(ts.libstring, 'SetSystemParameter',...
    enuminfo.SYSTEM_PARAMETER_TYPE.SELECT_TRANSMITTER, 0, 2));

% Set the power line frequency
handleError(ts,calllib(ts.libstring, 'SetSystemParameter',...
    enuminfo.SYSTEM_PARAMETER_TYPE.POWER_LINE_FREQUENCY, double(50.0), 8));

handleError(ts,calllib(ts.libstring, 'SetSystemParameter',...
    enuminfo.SYSTEM_PARAMETER_TYPE.MEASUREMENT_RATE, double(ts.samplerate), 8));

% Set to metric
handleError(ts,calllib(ts.libstring, 'SetSystemParameter',...
    enuminfo.SYSTEM_PARAMETER_TYPE.METRIC, logical(1), 4));

% Set recording type (doubles for positions and angle, include time and quality)
% We set this even for sensors that are not connected so that the output
% data will always be the same size
for sensor = 1:4 
    handleError(ts,calllib(ts.libstring, 'SetSensorParameter', sensor-1, ...
        enuminfo.SENSOR_PARAMETER_TYPE.DATA_FORMAT, ...
        int32(enuminfo.DATA_FORMAT_TYPE.DOUBLE_POSITION_ANGLES_TIME_Q), 4));
end

fprintf('Device setup complete\n');