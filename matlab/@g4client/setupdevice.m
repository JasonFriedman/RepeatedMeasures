% SETUPDEVICE - setup the device

function lc = setupdevice(lc)

% We get the update rate as a way of checking that the g4 is still
% answering us (and not stuck running some command or error)
if(getupdaterate(lc)~=120)
    error('Problem after getupdaterate');
end

% get a sample to check everything is working
result = getsinglesample(lc);
if isempty(result)
    error('Did not receive a result from the server - check everything is on and connected');
end
