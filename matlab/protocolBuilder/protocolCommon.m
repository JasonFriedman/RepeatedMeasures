% PROTOCOLCOMMON - set options that are the same for every trial (the common section)
%
% p = protocolCommon(p,name,value,...)
%
% e.g. p = protocolCommon(p,'starttrial','keyboard','showPosition',1);
%
% The options are those of a trial (see protocolTrial and protocolOptions('trial')).
% Note that common options replace the same option in every trial.
function p = protocolCommon(p,varargin)
values = pbTrialValues(varargin,'common');
names = fieldnames(values);
for k=1:numel(names)
    p.description.common.(names{k}) = values.(names{k});
end
