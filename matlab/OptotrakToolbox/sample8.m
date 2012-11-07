%Name:             SAMPLE8.M

%Description:

%    OPTOTRAK Sample Program #8.

%    1.  Load the system of transputers with the appropriate
%        transputer programs.
%    2.  Initiate communications with the transputer system.
%    3.  Load the appropriate camera parameters.
%    4.  Set up an OPTOTRAK collection.
%    5.  Activate the IRED markers.
%    6.  Initialize a file for spooling OPTOTRAK raw data.
%    7.  Spool the OPTOTRAK raw data to file.
%    8.  De-activate the IRED markers.
%    9.  Convert the OPTOTRAK raw data file to a 3D data file.
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
coll.CollectionTime  =5;          %Number of seconds of data to collect.        
coll.PreTriggerTime  =0;          %Number of seconds to pre-trigger data by.    
coll.Flags={'OPTOTRAK_BUFFER_RAW_FLAG'};

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
optotrak('DataBufferInitializeFile',{'OPTOTRAK'},'R#001.S08');

%Spool data to the previously initialized file.
fprintf('Collecting data file...\n');
SpoolStatus=optotrak('DataBufferSpoolData');
fprintf('Spool Status: 0x%04x\n',SpoolStatus);

%De-activate the markers.
optotrak('OptotrakDeActivateMarkers')

%Convert the raw data in the file 'R#001.S08' and write the
%3D data to the file 'C#001.S08'.
fprintf('Converting OPTOTRAK raw data file...\n');
optotrak('FileConvert','R#001.S08','C#001.S08',{'OPTOTRAK_RAW'});
fprintf('File conversion complete.\n');

%Shutdown the transputer message passing system.
optotrak('TransputerShutdownSystem')

%Exit the program.
fprintf('\nProgram execution complete.\n');
