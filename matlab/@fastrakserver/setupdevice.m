% SETUPDEVICE - setup the Fastrak
%
% Send initial commands to get fastrak setup

function setupdevice(ftc)
    
initializeDevice(ftc);
sendmessage(ftc,m,'isServerRunning');
[response,success] = receivemessage(ftc);

if success < 0
  error('Error in Connecting to the server');
end 
