% MESSAGECODES - this lists the messages and their codes

function codes = messagecodes

codes.dummy = -1;

codes.closesocket = 1;
% Need to provide filename as first argument (without extension), the 
% program will prefix it with the appropriate data type (e.g. opto_) 
% and add .csv at the end (as the files are comma seperated files)
% The second argument is the number of markers. The third argument is the
% maximum number of frames to record
codes.setuprecording = 2;
% Start recording to the buffer (for later writing to a file)
codes.startrecording = 3;
% Stop recording (does not write the file - use savefile for this)
codes.stoprecording = 4;
% Get an individual sample
codes.getsample = 5;
% Get some summary data on the last trial recorded
codes.getDataSummary = 6;
% Mark an event in the recording device for later synchronization
codes.markEvent = 7;
% Save the file
codes.savefile = 8;
% Start sampling without recording to memory (only keeps the last frame)
codes.startwithoutrecord = 9;
% State of buttons (for tablet stylus)
codes.getbuttons = 10;
% Initialize the device
codes.initializeDevice = 11;
% Checking the server connection status
codes.isServerRunning = 12;
% Close down the device
codes.closeDevice = 13;
%get a previous sample at a specific time
codes.getprevioussample = 14;


% Don't use TransputerLoadSystem with a secondary host
codes.OPTO_TransputerLoadSystem = 51;
% Can provide flags in parameters (e.g. {{'SECONDARY_HOST_FLAG'}} )
codes.OPTO_TransputerInitializeSystem = 52;
% Need to provide filename with the camera parameters (e.g. 'TouchScreen')
codes.OPTO_OptotrakLoadCameraParameters = 53;
% Note that the status will be printed at the server, not the client
codes.OPTO_OptotrakPrintStatus = 54;
% Activate the markers
codes.OPTO_OptotrakActivateMarkers = 55;
% Deactivate the markers
codes.OPTO_OptotrakDeActivateMarkers = 56;
% Get the latest 3D data (must have one parameter - the number of markers)
codes.OPTO_DataGetLatest3D = 57;
% Shutdown the system
codes.OPTO_TransputerShutdownSystem = 58;
% Setup collection
codes.OPTO_OptotrakSetupCollection = 59;

% Set mode to ASCII (0) or binary (1)
codes.LIBERTY_SetMode = 70;
% Set units to inches (0) or cm (1)
codes.LIBERTY_SetUnits = 71;
% Set active hemisphere
codes.LIBERTY_SetHemisphere = 72;
% Set the sample rate (3 = 120Hz, 4 = 240Hz)
codes.LIBERTY_SetSampleRate = 73;
% Reset the frame count
codes.LIBERTY_ResetFrameCount = 74;
% Set output format
codes.LIBERTY_SetOutputFormat = 75;
% Get a single sample
codes.LIBERTY_GetSingleSample = 76;
% Get the update rate
codes.LIBERTY_GetUpdateRate = 77;
% Set the alignment frame (which way is x,y,z)
codes.LIBERTY_AlignmentReferenceFrame = 78;

% Wake up minibird
codes.MINIBIRD_birdRS232WakeUp = 80;

% Attach to the Wacom tablet
codes.TABLET_attachTablet = 90;
% Close the interface
codes.TABLET_closeInterface = 91;

% Force sensors
codes.FORCESENSORS_setParameters = 100;
codes.FORCESENSORS_getParameters = 101;

% Set the hemisphere (0 = FRONT (forward), 1 = BACK (rear), 2 = TOP (upper), 3 = BOTTOM (lower),4 = LEFT, and 5 =  RIGHT)
codes.TRAKSTAR_SetHemisphere = 120;

codes.GLOVE_getRawData = 130;

codes.SERIALPORT_sendTrigger = 140;

codes.DAQ_sendTrigger = 150;

%% Mark event codes [ Not that these are separate from the above codes, so they can overlap]

% First frame displayed
codes.firstFrame = 5;
% After last frame displayed (first blank frame)
codes.lastFrame = 6;
% Beeped
codes.beeped = 7;
% Sound file played
codes.soundPlayed = 8;
% Target on: value in file will be 1000 + target number
codes.targetOn = 1000;
% Sent a tactor stimuli: value in file will be 2000 + sequence number
codes.tactored = 2000;
% Stimulus on
codes.stimulusOn = 10;
% trigger marked in file will be 20 + value sent (i.e., high = 21, low = 20)
codes.triggerSent = 20;
% Image state changed, value marked in file will be 100 + imageState
codes.imageState = 100;
% Triggers received, marked in file will be 1000 + value
codes.triggerReceived = 1000;

% codes for video recording (copied from recordVideoProtocol.h)

% The format of the protocol is as follows:
% [command (1 character)] [1st argument (3 characters)] [2nd argument (95 characters)]

codes.rvCloseServer = 'C';
codes.rvCloseSocket = 'c';
codes.rvRecordVideo = 'R';
codes.rvMarkTime = 'm';
