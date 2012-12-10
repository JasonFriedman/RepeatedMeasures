% SETUPDEVICES - setup recording and other devices
% e = setupdevices(e)

function e = setupdevices(e,debug)

if nargin<2 || isempty(debug)
    debug = 0;
end

if nargout<1
    error('You must use the return value of this function to access the devices in later calls');
end

if isempty(e.devices)
    warning('There are no recording devices set up');
    e.devices = struct([]);
else
    devicelist = fields(e.devices);
    for k=1:length(devicelist)
        clientparameters = e.protocol.setup.(devicelist{k});
        eval(['e.devices.' devicelist{k} ' = ' devicelist{k} 'client(clientparameters,e,debug);']);
        setupdevice(e.devices.(devicelist{k}));
        writetolog(e,['Connected to ' devicelist{k}]);
    end
end

% still need to work out where to put this
if e.MCPresent
    % Setup the card for triggering the MC device
    dllpath = [pwd '\cbw'];
    in_or_out = str2double(e.protocol.setup.MCtrigger);
    e.MCtrigger = MCtrigger(dllpath,in_or_out);
    writetolog(e,'Opened MC library');
end
