%Name:             SAMPLE1.M

%Description:

%    OPTOTRAK Sample Program #1.

%    1.  Load the system of transputers with the appropriate
%        transputer programs.
%    2.  Initiate communications with the transputer system.
%    3.  Load the appropriate camera parameters.
%    4.  Request/receive/display the current OPTOTRAK system status.
%        Pass NULL for those status variables that are not
%        requested.
%    5.  Disconnect the PC application program from the transputer
%        system.

%Just to be on the save side, we first reset all Matlab functions:
clear functions

%Load the system of transputers.
optotrak('TransputerLoadSystem','system');

%Wait one second to let the system finish loading.
pause(1);

%Initialize the transputer system.
optotrak('TransputerInitializeSystem',{'OPTO_LOG_ERRORS_FLAG'})

%Load the standard camera parameters.
optotrak('OptotrakLoadCameraParameters','standard')

%Request and print the OPTOTRAK status.
optotrak('OptotrakPrintStatus')

%%Shutdown the transputer message passing system.
optotrak('TransputerShutdownSystem')

%Exit the program.
fprintf('\nProgram execution complete.\n');
