% RMTESTDEVICESERVER - a simulated device server for tests (no hardware needed)
%
% d = rmtestdeviceserver(port,framerate,options)
%
% options is a struct with the (optional) fields
%   prefix      prefix of the data files (default 'sim_')
%   sampleFcn   function handle, data = sampleFcn(t) returning one row of data for time t
%               (default @(t) [sin(t) cos(t) 0])
%   commandFcn  function handle, returnValue = commandFcn(command,parameters), called for
%               device specific commands (default: NaN, which means that nothing is sent back)
%   summaryFcn  function handle, dataSummary = summaryFcn(data) (default: struct with the
%               field toSave)
%
% A column with the time is appended to the data, and (as for all servers) the last
% column of the saved file is the event marker.
function d = rmtestdeviceserver(port,framerate,options)
if nargin<3 || isempty(options)
    options = struct;
end
d.prefix = 'sim_';
d.sampleFcn = @(t) [sin(t) cos(t) 0];
d.commandFcn = @(command,parameters) NaN;
d.summaryFcn = [];
f = fieldnames(options);
for k=1:numel(f)
    if ~isfield(d,f{k})
        error('Unknown option %s for rmtestdeviceserver',f{k});
    end
    d.(f{k}) = options.(f{k});
end
d = class(d,'rmtestdeviceserver',socketserver(port,framerate,0));
