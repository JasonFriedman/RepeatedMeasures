%Name:             SAMPLE2.M

%Description:

%    OPTOTRAK Sample Program #2.

%    1.  Load the system of transputers with the appropriate
%        transputer programs.
%    2.  Initiate communications with the transputer system.
%    3.  Set the optional processing flags to do the 3D conversions
%        on the host computer.
%    4.  Load the appropriate camera parameters.
%    5.  Set up an OPTOTRAK collection.
%    6.  Activate the IRED markers.
%    7.  Request/receive/display 10 frames of real-time 3D data.
%    8.  De-activate the markers.
%    9.  Disconnect the PC application program from the transputer
%        system.

%Just to be on the save side, we first reset all Matlab functions:
clear functions

%Settings:
coll.NumMarkers      =6;   %Number of markers in the collection.         
coll.FrameFrequency  =100; %Frequency to collect data frames at.          
coll.MarkerFrequency =2500;%Marker frequency for marker maximum on-time. 
coll.Threshold       =30;  %Dynamic or Static Threshold value to use.    
coll.MinimumGain     =160; %Minimum gain code amplification to use.      
coll.StreamData      =0;   %Stream mode for the data buffers.            
coll.DutyCycle       =0.35;%Marker Duty Cycle to use.                    
coll.Voltage         =7;   %Voltage to use when turning on markers.      
coll.CollectionTime  =1;   %Number of seconds of data to collect.        
coll.PreTriggerTime  =0;   %Number of seconds to pre-trigger data by.    
coll.Flags={'OPTOTRAK_BUFFER_RAW_FLAG';'OPTOTRAK_GET_NEXT_FRAME_FLAG'};

%Load the system of transputers.
optotrak('TransputerLoadSystem','system');

%Wait one second to let the system finish loading.
pause(1);

%Initialize the transputer system.
optotrak('TransputerInitializeSystem',{'OPTO_LOG_ERRORS_FLAG'});

%Set optional processing flags (this overides the settings in OPTOTRAK.INI).
optotrak('OptotrakSetProcessingFlags',...
         {'OPTO_LIB_POLL_REAL_DATA';
          'OPTO_CONVERT_ON_HOST';
          'OPTO_RIGID_ON_HOST'});

%Load the standard camera parameters.
optotrak('OptotrakLoadCameraParameters','standard');

%Set up a collection for the OPTOTRAK.
optotrak('OptotrakSetupCollection',coll);

%Wait one second to let the camera adjust.
pause(1);

%Activate the markers.
optotrak('OptotrakActivateMarkers')

%Get and display 10 frames of 3D data.
fprintf('\n\n3D Data Display\n');
for FrameCnt = 1:10
  fprintf('\n');
  %Get a frame of data.
  data=optotrak('DataGetLatest3D',coll.NumMarkers);
  %Print out the data.
  fprintf('Frame Number: %8u\n',data.FrameNumber);
  fprintf('Elements    : %8u\n',data.NumMarkers);
  fprintf('Flags       : 0x%04x\n',data.Flags);
  for MarkerCnt = 1:coll.NumMarkers
    fprintf('Marker %u X %f Y %f Z %f\n', MarkerCnt,...
            data.Markers{MarkerCnt}(1),...
            data.Markers{MarkerCnt}(2),...
            data.Markers{MarkerCnt}(3))
  end
end

%De-activate the markers.
optotrak('OptotrakDeActivateMarkers')

%Shutdown the transputer message passing system.
optotrak('TransputerShutdownSystem')

%Exit the program.
fprintf('\nProgram execution complete.\n');
