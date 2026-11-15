% RUNCOMMAND - device specific commands are answered by the commandFcn
function [returnValue,changedParameters,changedValues] = runcommand(d,command,parameters)
changedParameters = {};
changedValues = {};
returnValue = d.commandFcn(command,parameters);
