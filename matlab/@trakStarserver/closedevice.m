% CLOSEDEVICE - perform any operations necessary when closing a device
% (e.g. tell it to shutdown). Subclasses should override this if necessary

function closedevice(ts)

enuminfo = getEnums;

% Turn off Transmitter
handleError(ts,calllib(ts.libstring, 'SetSystemParameter',...
    enuminfo.SYSTEM_PARAMETER_TYPE.SELECT_TRANSMITTER, -1, 2));

% Close tracker 
handleError(ts,calllib(ts.libstring, 'CloseBIRDSystem'));