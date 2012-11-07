% SETUPDEVICE - setup the device

function lc = setupdevice(lc)

% Set the mode to binary
setmode(lc,1);
pause(0.5);

% Set the sample rate to 240 Hz
setsamplerate(lc);
pause(0.5);
if(getupdaterate(lc)~=lc.samplerate)
    error('Problem after setsamplerate');
end

% We get the update rate as a way of checking that the liberty is still
% answering us (and not stuck running some command or error)
if(getupdaterate(lc)~=lc.samplerate)
    error('Problem after setmode');
end

% set the units to cm
setunits(lc,1);
pause(0.5);
if(getupdaterate(lc)~=lc.samplerate)
    error('Problem after setunits');
end

% set the active hemisphere
for k=1:lc.numsensors
    sethemisphere(lc,k);
    pause(0.5);
end
if(getupdaterate(lc)~=lc.samplerate)
    error('Problem after sethemisphere');
end


% Reset the frame count
resetframecount(lc);
pause(0.5);
if(getupdaterate(lc)~=lc.samplerate)
    error('Problem after resetframecount');
end

% set the output format
for k=1:lc.numsensors
    setoutputformat(lc,k);
    pause(0.5);
end
if(getupdaterate(lc)~=lc.samplerate)
    error('Problem after setoutputformat');
end

% set the alignment reference frame (which way are x,y,z)
for k=1:lc.numsensors
    setalignmentframe(lc,k);
    pause(0.5);
end
if(getupdaterate(lc)~=lc.samplerate)
    error('Problem after setalignmentframe');
end

% get a sample to check everything is working
result = getsinglesample(lc);
if isempty(result)
    error('Did not receive a result from the server - check everything is on and connected');
end
