%Name:             SAMPLE5CONVERT.M

%Description:
%    This is an addition to OPTOTRAK sample program #5:
%    - Converts the raw data file generated in sample #5. 
%      (this generates the 3D data file C#001.S05 from the 
%      raw data file R#001.S05)

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
optotrak('OptotrakSetupCollection',coll);

optotrak('FileConvert','R#001.S05','C#001.S05',{'OPTOTRAK_RAW'});

%Shutdown the transputer message passing system.
optotrak('TransputerShutdownSystem')

%Exit the program.
fprintf('\nProgram execution complete.\n');

