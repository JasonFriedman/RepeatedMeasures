% BLUETERAMEX - send commands and receive data from the blueTera
%
% The sensor will sample continuously, when called it will return the latest value
% There is no caching of data between calls - duplicate data can be identified via the time stamp
%
% blueTeraMex(0) - initialize the bluetooth
% blueTeraMex(1,{'F9:D1:B1:98:55:F7'}) - setup connection for the specified 
%                                        sensors(s), specified in a cell array
% [numSensors,states] = blueTeraMex(2) - get the number of sensors and their states. 
%                                        The states are 0 = connected,  
%                                        2 = disconnected, 5 = uninitialized, 7 = discovered
% out = blueTeraMex(3)                 - Get the latest sample. This will be a numSensors * 9
%                                        matrix. In each row, the first 4 values are the 
%                                        quaternion, the next 3 the accelerations, the 8th value
%                                        is the quaternion timestamp (in ms), the 9th value is the 
%                                        acceleration timestamp (in ms)
% blueTeraMex(4)                       - Disconnect from the sensors and release the bluetooth
% addresses = blueTeraMex(5,time)      - Return the addresses of the discovered blueTera devices
%                                        time is the amount of time to scan in seconds (default = 10)
%                                        
%
% Sample usage (for one sensor)
% blueTeraMex(0);
% pause(1); 
% sensors = blueTeraMex(5,5);
% if numel(sensors)==0
%      error('No sensors found');
% end
% blueTeraMex(1,sensors);
% [numSensors,states] = blueTeraMex(2);
% while(states(1)~=0)
%    fprintf('Not yet connected . . \n');
%    pause(1);
%    [numSensors,states] = blueTeraMex(2);
% end
% pause(1);
% output = blueTeraMex(3);
% output(1:7)
% output(8:9)
% blueTeraMex(4);
% clear mex; % Make sure it is removed from memory