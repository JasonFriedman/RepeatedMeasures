% INITIALIZEDEVICE - perform any operations necessary when setting up a device
% Subclasses should override this if necessary

function cgs = initializeDevice(cgs)
cgs.isConnected = GloveMex(0);
