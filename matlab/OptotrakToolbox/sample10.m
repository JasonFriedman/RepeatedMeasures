%Name:             SAMPLE10.M

%Description:

%    OPTOTRAK Sample Program #10.

%    1.  Load the system of transputers with the appropriate
%        transputer programs.
%    2.  Initiate communications with the transputer system.
%    3.  Load the appropriate camera parameters.
%    4.  Set up an OPTOTRAK collection.
%    5.  Activate the IRED markers.
%    6.  Add a rigid body to the OPTOTRAK System tracking list using
%        a .RIG file.
%    7.  Change the default settings for the rigid body just added.
%    8.  Request/receive/display 10 frames of rigid body transforms
%        in Quaternion format; also display the attached 3D marker
%        position data.
%    9.  De-activate the IRED markers.
%    10. Disconnect the PC application program from the transputer
%        system.

%Just to be on the save side, we first reset all Matlab functions:
clear functions

%Settings for Optotrak collection:
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

%Constants for identifying the rigid bodies:
NumRigids = 1;
RBfileset.RigidBodyIndex = 1; %Index associated with this rigid body.
RBfileset.StartMarker    = 1; %First marker in the rigid body
RBfileset.RigFile        = 'plate';%RIG file containing rigid body coordinates

%VF: The following command is added for better stability (cf. sample9.c):
%    This is not a problem of the OptotrakToolbox, but of the NDI samples!!!
%Set optional processing flags (this overides the settings in OPTOTRAK.INI).
optotrak('OptotrakSetProcessingFlags',{'OPTO_LIB_POLL_REAL_DATA',
                    'OPTO_CONVERT_ON_HOST',
                    'OPTO_RIGID_ON_HOST'});

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

% Add rigid body 1 for tracking to the OPTOTRAK system from a .RIG file.
optotrak('RigidBodyAddFromFile',RBfileset);

%Change the default settings for this rigid body:
RBset.RigidBodyIndex   = RBfileset.RigidBodyIndex; %ID associated with rigid body
RBset.MinMarkers       = 4;   %Min number of markers which must be seen
RBset.MaxMarkersAngle  = 60;  %Cut off angle for marker inclusion in calcs
RBset.Max3dError       = 0.25;%Max 3-D marker error for rigid body
RBset.MaxSensorError   = 1;   %Max raw sensor error for rigid body
RBset.Max3dRmsError    = 1;   %Max 3-D RMS marker error for rigid body
RBset.MaxSensorRmsError= 1;   %Max raw sensor RMS error for rigid body
RBset.Flags            = {'OPTOTRAK_QUATERN_RIGID_FLAG','OPTOTRAK_RETURN_QUATERN_FLAG'}
optotrak('RigidBodyChangeSettings',RBset);

%Get and display 10 frames of rigid body data.
fprintf('Rigid Body Data Display\n');
for FrameCnt = 1:10
  %Get a frame of data.
  data=optotrak('DataGetLatestTransforms',coll.NumMarkers,NumRigids);

  %Print out the rigid body transformation data.
  fprintf('\n');
  fprintf('Rigid Body Transformation Data\n\n');
  fprintf('Frame Number: %8u\n',data.FrameNumber);
  fprintf('Transforms  : %8u\n',data.NumRigids);
  fprintf('Flags       :   0x%04x\n',data.Flags);
  for RigidCnt = 1:data.NumRigids
    fprintf('Rigid Body %u\n',RigidCnt);
    fprintf('%s\n',data.Rigids{RigidCnt}.TransformError);
    fprintf('XT = %8.2f YT = %8.2f ZT = %8.2f\n',...
            data.Rigids{RigidCnt}.Trans(1),...
            data.Rigids{RigidCnt}.Trans(2),...
            data.Rigids{RigidCnt}.Trans(3));
    fprintf('Q0 = %8.2f QX = %8.2f QY = %8.2f QZ = %8.2f\n',...
            data.Rigids{RigidCnt}.RotQuaternion(1),...
            data.Rigids{RigidCnt}.RotQuaternion(2),...
            data.Rigids{RigidCnt}.RotQuaternion(3),...
            data.Rigids{RigidCnt}.RotQuaternion(4));
  end

  % Print out the 3D data.
  fprintf('\nAssociated 3D Marker Data\n\n');
  for MarkerCnt = 1:data.NumMarkers    
    fprintf('Marker %u X %7.2f Y %7.2f Z %7.2f\n',...
            MarkerCnt,...
            data.Markers{MarkerCnt}(1),...
            data.Markers{MarkerCnt}(2),...
            data.Markers{MarkerCnt}(3));
  end
end

%De-activate the markers.
optotrak('OptotrakDeActivateMarkers')

%Shutdown the transputer message passing system.
optotrak('TransputerShutdownSystem')

%Exit the program.
fprintf('\nProgram execution complete.\n');
