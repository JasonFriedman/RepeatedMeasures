% INITIALIZEDEVICE - perform any operations necessary when setting up a device
% Subclasses should override this if necessary

function fts = initializeDevice(fts)
no_of_receivers = get(fts, 'receivers');
fts.isConnected = FastrakMex(0, no_of_receivers);
