% VCRDMstimulus - class representing "variable coherence random dot" stimulus 
%
% Based on the VCRDM code written by Maria Mckinley, available from
% http://www.shadlenlab.columbia.edu/Code/VCRDM

function [v,params] = VCRDMstimulus(inputParams,experimentdata)

params.name = {'percentCoherent','percentAccurate','speed','direction','numFrames'};
params.type = {'number','number','number','number','number'};
params.description = {'percent of dots that will move coherently (between 0 and 100)',...
                      'accuracy (coherence level will then be set from the QUEST staircase',...
                      'speed of the dots',...
                      'direction (in degrees)',...
                      'number of frames to show the dots'};
params.required = [0 0 1 1 1];
params.default = {[],[],0,0,0};
params.classdescription = 'Variable coherence random dot kinematograms';
params.classname = 'VCRDMstimulus';
params.parentclassname = 'stimulus';

if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

if isempty(v.percentCoherent) && isempty(v.percentAccurate)
    error('A value must be specified for either percentCoherent or percentAccurate in VCRDM stimulus');
end

v = class(v,'VCRDMstimulus',stimulus(parent));
