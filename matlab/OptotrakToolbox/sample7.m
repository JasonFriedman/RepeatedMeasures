%Name:             SAMPLE7.M

%Description:

%    OPTOTRAK Sample Program #7.
%    1.  Load the system of transputers with the appropriate
%        transputer programs.
%    2.  Initiate communications with the transputer system.
%    3.  Load the appropriate camera parameters.
%    4.  Set up an OPTOTRAK collection.
%    5.  Activate the IRED markers.
%    6.  Initialize a file for spooling OPTOTRAK 3D data.
%    7.  Start the OPTOTRAK spooling when Marker 1 is seen.
%    8.  Spool 3D data to file while at the same time requesting and
%        examining 3D data.
%    9.  Stop the spool once Marker 1 goes out of view or after 100
%        seconds of data has been spooled.
%    10. De-activate the markers.
%    11. Disconnect the PC application program from the transputer
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
coll.CollectionTime  =100;        %Number of seconds of data to collect.        
coll.PreTriggerTime  =0;          %Number of seconds to pre-trigger data by.    

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
optotrak('DataBufferInitializeFile',{'OPTOTRAK'},'C#001.S07');

%Loop until marker 1 comes into view.
fprintf('Waiting for marker 1...\n');
while 1
  %Get a frame of 3D data:
  data=optotrak('DataGetLatest3D',coll.NumMarkers);
  %Break infinite while loop, if marker 1 is visible:
  if ~isnan(data.Markers{1})
    break
  end
end

%Start the OPTOTRAK spooling data to us.
optotrak('DataBufferStart')
fprintf('Collecting data file...\n');

%Loop around spooling data to file until marker 1 goes out of view.
SpoolComplete=0;
while ~SpoolComplete
  %Get a frame of 3D data:
  data=optotrak('DataGetLatest3D',coll.NumMarkers);

  %Check to see if marker 1 is out of view and stop the OPTOTRAK from
  %spooling data if this is the case:
  if isnan(data.Markers{1})
    optotrak('DataBufferStop');
  end

  %Write data if there is any to write.
  [RealtimeDataReady,SpoolComplete,SpoolStatus,FramesBuffered]=optotrak('DataBufferWriteData');
end
fprintf('Spool Status: 0x%04x\n',SpoolStatus);

%De-activate the markers.
optotrak('OptotrakDeActivateMarkers')

%Shutdown the transputer message passing system.
optotrak('TransputerShutdownSystem')

%Exit the program.
fprintf('\nProgram execution complete.\n');
