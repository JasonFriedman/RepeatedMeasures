% INITIALIZEDEVICE Setup the sensors
%
% initializeDevice(r)

function r = initializeDevice(r)

if numel(r.addresses) ~= r.numsensors
    error(sprintf('The number of addresses (%d) does not match the number of sensors specified (%d)',...
        numel(r.addresses),r.numsensors));
end

redamberMex(1,r.addresses);
