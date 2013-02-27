% LIBERTYMEX - send commands and receive data from the Liberty
%
% In all the below, numMarkers = the number of markers connected
%                   dataRequested = 1 is just orientation is requested, 2 for position + orientation
%                   station = the marker number to set something for (starts from 1)
%
% LibertyMex(0) - initialize and connect to the Liberty
% out = LibertyMex(1,numMarkers) - Get a single sample when not in continuous mode
% LibertyMex(2) - Start continuous mode
% out = LibertyMex(3,numMarkers,dataRequested) - Get a sample in continuous mode
% LibertyMex(4) - Stop continuous mode
% LibertyMex(5) - Disconnect from the Liberty 
% frameRate = LibertyMex(6); - get the current frame rate
% LibertyMex(7,binaryOrASCII) - set the tracker to use binary (1) or ASCII (0)
% LibertyMex(8,units) - set the units to use: inches(0) or cm (1)
% LibertyMex(9,station,x,y,z) - Set the active hemisphere for station in the direction (x,y,z)
% LibertyMex(10,frameRate) - Set the frame rate in Hz (120 or 240)
% LibertyMex(11) - Reset the frame count
% LibertyMex(12,station,dataRequestd) - set the output data format for a station
% LibertyMex(13,station) - Clear the alignment frame
% LibertyMex(14,station,O1,O2,O3,X1,X2,X3,Y1,Y2,Y3) - Set the alignment frame to (O1,O2,O3), (X1,X2,X3), (Y1,Y2,Y3)
%                                                     O is the origin, X and Y are vectors in the direction of the X and Y axes
%
% Sample usage (for one marker)
% LibertyMex(0);
% output = LibertyMex(1,1);
% LibertyMex(5);