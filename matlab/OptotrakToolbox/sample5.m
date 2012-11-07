%Name:             SAMPLE5.M

%Description:

%    OPTOTRAK Sample Program #5.
%    1.  Load the system of transputers with the appropriate
%        transputer programs.
%    2.  Initiate communications with the transputer system.
%    3.  Load the appropriate camera parameters.
%    4.  Set up an OPTOTRAK collection.
%    5.  Activate the IRED markers.
%    6.  Initialize a data file for spooling OPTOTRAK data.
%    7.  Start the OPTOTRAK spooling raw sensor data.
%    8.  Spool raw data to file while at the same time request
%        and display real-time 3D data.
%    9.  De-activate the markers.
%    10. Disconnect the PC application program from the transputer
%        system.

%Just to be on the save side, we first reset all Matlab functions:
clear functions

%Settings:
coll.NumMarkers      =6;          %Number of markers in the collection.         
coll.FrameFrequency  =50 ;        %Frequency to collect data frames at.          
coll.MarkerFrequency =2500;       %Marker frequency for marker maximum on-time. 
coll.Threshold       =30;         %Dynamic or Static Threshold value to use.    
coll.MinimumGain     =160;        %Minimum gain code amplification to use.      
coll.StreamData      =1;          %Stream mode for the data buffers.            
coll.DutyCycle       =0.4;        %Marker Duty Cycle to use.                    
coll.Voltage         =7.5;        %Voltage to use when turning on markers.      
coll.CollectionTime  =4;          %Number of seconds of data to collect.        
coll.PreTriggerTime  =0;          %Number of seconds to pre-trigger data by.    
coll.Flags={'OPTOTRAK_BUFFER_RAW_FLAG';'OPTOTRAK_GET_NEXT_FRAME_FLAG'};

%Load the system of transputers.
optotrak('TransputerLoadSystem','system');

%Wait one second to let the system finish loading.
pause(1);

%Initialize the transputer system.
optotrak('TransputerInitializeSystem',{'OPTO_LOG_ERRORS_FLAG'})

%Load the standard camera parameters.
optotrak('OptotrakLoadCameraParameters','standard');

%Set up a collection for the OPTOTRAK.
optotrak('OptotrakSetupCollection',coll)

%Wait one second to let the camera adjust.
pause(1);

%Activate the markers.
optotrak('OptotrakActivateMarkers')

%Initialize a file for spooling of the OPTOTRAK data.
optotrak('DataBufferInitializeFile',{'OPTOTRAK'},'R#001.S05');

%Start the OPTOTRAK spooling data to us.
optotrak('DataBufferStart')

%Request a frame of realtime 3D data.
optotrak('RequestLatest3D')

%Loop around spooling data to file and displaying realtime 3d data.
SpoolComplete=0;
while(~SpoolComplete)
  %Write data if there is any to write.
  [RealtimeDataReady,SpoolComplete,SpoolStatus,FramesBuffered]=optotrak('DataBufferWriteData');

  %Display realtime if there is any to display.
  if(RealtimeDataReady)
    %Receive the 3D data.
    data=optotrak('DataReceiveLatest3D',coll.NumMarkers);
    %Print out the data.
    fprintf('Frame Number: %8u\n',data.FrameNumber);
    fprintf('Elements    : %8u\n',data.NumMarkers);
    fprintf('Flags       : 0x%04x\n',data.Flags);
    for MarkerCnt = 1:coll.NumMarkers
      fprintf('Marker %u X %8.2f Y %8.2f Z %8.2f\n', MarkerCnt,...
              data.Markers{MarkerCnt}(1),...
              data.Markers{MarkerCnt}(2),...
              data.Markers{MarkerCnt}(3))
    end
  end

  %Request a new frame of realtime 3D data.
  optotrak('RequestLatest3D')
  RealtimeDataReady = 0;
end
fprintf('Spool Status: 0x%04x\n',SpoolStatus);

%De-activate the markers.
optotrak('OptotrakDeActivateMarkers')

%Shutdown the transputer message passing system.
optotrak('TransputerShutdownSystem')

%Exit the program.
fprintf('\nProgram execution complete.\n');
