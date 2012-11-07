%Name:             SAMPLE20.M

%Description:

%    OPTOTRAK Sample Program #20.

%    1.  Determine the system configuration and generate the
%        external NIF configuration file, system.nif.
%    2.  Load the system of transputers with the appropriate
%        transputer programs based on the external file,
%        system.nif.
%    3.  Initiate communications with the transputer system.
%    4.  Disconnect the PC application program from the transputer
%        system.
%    5.  Set the API to use the internally generated and stored
%        system NIF configuration.
%    6.  Determine the system configuration and store the
%        NIF information internally.
%    7.  Load the system of transputers with the appropriate
%        transputer programs based on the internal NIF configuration.
%    8.  Initiate communications again with the transputer system.
%    9.  Disconnect the PC application program from the transputer
%        system again.

%Just to be on the save side, we first reset all Matlab functions:
clear functions

%Settings:
LogFileName = 'CfgLog.txt';

%Determine the system configuration in the default manner
%without any error logging. This writes the file system.nif
%in the standard ndigital directory.
fprintf('Determining system configuration using system.nif.\n');
optotrak('TransputerDetermineSystemCfg');

%Load the system of transputers using the file system.nif.
fprintf('Loading & initializing transputer system...\n');
optotrak('TransputerLoadSystem','system');

%Wait one second to let the system finish loading.
pause(1);

%Initialize the transputer system.
optotrak('TransputerInitializeSystem',{'OPTO_LOG_ERRORS_FLAG'})

%Shutdown the transputer message passing system.
optotrak('TransputerShutdownSystem')

%Set the API to use internal storage for the system
%configuration.
fprintf('\nDetermining system configuration using internal strings.\n');
optotrak('OptotrakSetProcessingFlags',{'OPTO_USE_INTERNAL_NIF'});

%Determine the system configuration again, but this time
%with error logging.
optotrak('TransputerDetermineSystemCfg',LogFileName);

%Load the system of transputers - no argument defaults to the
%internal NIF configuration.
fprintf('Loading & initializing transputer system...\n');
optotrak('TransputerLoadSystem');
pause(1);

%Initialize the transputer system again in the usual manner.
optotrak('TransputerInitializeSystem',{'OPTO_LOG_ERRORS_FLAG'})

%Shutdown the transputer message passing system.
optotrak('TransputerShutdownSystem')

%Exit the program.
fprintf('\nProgram execution complete.\n');
