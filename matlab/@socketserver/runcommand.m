% RUNCOMMAND - This function needs to be implemented in the child class
% If this is being run, it will give an error
%
% returnValue = runcommand(s,command,parameters)

function returnValue = runcommand(s,command,parameters)

error(['Runcommand needs to be implemented in the child class to implement command ' num2str(command)]);
