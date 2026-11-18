% PROTOCOLDEFINETARGETS - add trials in which target positions are defined
%
% p = protocolDefineTargets(p,names)
% p = protocolDefineTargets(p,names,name,value,...)    with extra trial options
%
% e.g. p = protocolDefineTargets(p,{'Start position','Left target','Right target'});
%
% One trial per name: the name is shown, and the position of the sensor / pen when space
% is pressed becomes target 1, 2, ... (the defineTarget response). These targets are then
% used by e.g. the targetInSpace start and response and by pointToPoint.
function p = protocolDefineTargets(p,names,varargin)
if ischar(names)
    names = {names};
end
first = 0;
for k=1:numel(p.description.trial)
    t = p.description.trial{k};
    if isfield(t,'targetType') && isstruct(t.targetType) && isfield(t.targetType,'defineTarget')
        first = max(first,t.targetType.defineTarget.targetNum);
    end
end
for k=1:numel(names)
    p = protocolTrial(p,'stimulus',{'showText','text',names{k}},...
        'response',{'defineTarget','targetNum',first+k},...
        'recordingTime',inf,'recording',0,'block','define targets',varargin{:});
end
