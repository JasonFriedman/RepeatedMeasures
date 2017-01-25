% REDAMBERMEX - send commands and receive data from the red amber
%
% The sensor will sample continuously, when called it will return the latest value
% There is no caching of data between calls - duplicate data can be identified via the time stamp
%
% redamberMex(0) - initialize the bluetooth
% redamberMex(1,{'00:80:98:DC:9F:EC'}) - setup connection for the specified 
%                                        gem(s), specified in a cell array
% [numGems,states] = redamberMex(2)    - get the number of gems and their states. 
%                                        The states are 0 = connected, 1 = connecting, 
%                                        2 = disconnected, 3 = disconnecting, 5 = uninitialized
% out = redamberMex(3)                 - Get the latest sample. This will be a numGems * 8
%                                        matrix. In each row, the first 4 values are the 
%                                        quaternion, the next 3 the accelerations, the last value
%                                        is a timestamp (in seconds)
% redamberMex(4)                       - Disconnect from the gems and release the bluetooth
%
% Sample usage (for one gem)
% redamberMex(0);
% pause(1); 
% redamberMex(1,{'00:80:98:DC:9F:EC'});
% [numGems,states] = redamberMex(2);
% while(states(1)~=0)
%    fprintf('Not yet connected . . \n');
%    pause(1);
%    [numGems,states] = redamberMex(2);
% end
% output = redamberMex(3)
% redamberMex(4);