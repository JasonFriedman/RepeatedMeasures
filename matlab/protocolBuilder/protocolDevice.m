% PROTOCOLDEVICE - add a recording device to a protocol
%
% p = protocolDevice(p,name,option,value,...)
%
% e.g. p = protocolDevice(p,'tablet','maxx',48767,'maxy',30479);
%      p = protocolDevice(p,'liberty','numsensors',1,'recordOrientation',1);
%      p = protocolDevice(p,'keyboard');
%
% server defaults to 'localhost' and port to the port used by the run<device>server
% script, so they only need to be given when they are different. Required options that
% are missing are reported immediately.
%
% protocolOptions('devices') lists the devices, protocolOptions('tablet') their options.
function p = protocolDevice(p,name,varargin)
schema = protocolSchema;
if ~isfield(schema.devices,name)
    error('protocolBuilder:unknown','There is no device called %s.%s',name,pbSuggest(name,fieldnames(schema.devices)));
end
opts = pbToStruct(varargin,name);
if ~isfield(opts,'server')
    opts.server = 'localhost';
end
if ~isfield(opts,'port')
    port = defaultPort(name);
    if isnan(port)
        error('protocolBuilder:missing','%s has no standard port: specify it with ''port'',number',name);
    end
    opts.port = port;
end
params = schema.devices.(name);
opts = pbCheck(opts,params,name,schema);
missing = {};
for k=1:numel(params)
    if any(params(k).required==[1 3]) && ~isfield(opts,params(k).name)
        missing{end+1} = params(k).name; %#ok<AGROW>
    end
end
if ~isempty(missing)
    error('protocolBuilder:missing','The device %s needs: %s (see protocolOptions(''%s''))',name,strjoin(missing,', '),name);
end
p.description.setup.(name) = opts;

function port = defaultPort(name)
% The port is read from the run<name>server.m script that starts the server
port = NaN;
script = fullfile(fileparts(fileparts(mfilename('fullpath'))),['run' name 'server.m']);
if exist(script,'file')
    tok = regexp(fileread(script),[name 'server\((\d+)'],'tokens','once','ignorecase');
    if ~isempty(tok)
        port = str2double(tok{1});
    end
end
