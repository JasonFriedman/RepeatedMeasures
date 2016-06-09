% G4MEX - send commands and receive data from the G4
%
% In all the below, numMarkers = the number of markers connected
%
% G4Mex(0,configurationFilePath) - initialize and connect to the G4
% out = G4Mex(1,numMarkers) - Get a single sample when not in continuous mode
% G4Mex(2) - Start continuous mode
% out = G4Mex(3,numMarkers) - Get a sample in continuous mode
% G4Mex(4) - Stop continuous mode
% G4Mex(5) - Disconnect from the G4 
% frameRate = G4Mex(6); - get the current frame rate
%
% Sample usage (for one marker)
% G4Mex(0,'c:\configurationfile.g4c');
% output = G4Mex(1,1);
% G4Mex(5);