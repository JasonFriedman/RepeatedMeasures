% QUESTstaircase - prepare a QUEST staircase

function [qs,params] = QUESTstaircase(inputParams,experiment,debug)

params.name = {'tGuess','tGuessSd','pThreshold','beta','delta','gamma','min','max'};
params.type = {'number','number','number','number','number','number','number','number'};
params.description = {'Prior threshold estimate','Standard deviation of guess','threshold criterion (midpoint of table will yield this threshold',...
    'beta parameter of Weibell function (steepness)','delta parameter of Weiball function (fraction of trials the observer presses blindly)',...
    'gamma parameter of Weibell function (fraction of trials that will generate response 1 when stimulus intensity = -inf',...
    'minimum value to show - the value shown will always be >= to this value, regardless of what Quest suggests',...
    'maximum value to show - the value shown will always be <= to this value, regardless of what Quest suggests'};
params.required = [1 1 1 0 0 0 0 0];
params.default = {0,0.5,0.75,3.5,0.01,0.5,-inf,inf};
params.classdescription = 'A QUEST staircase. See documentation for QuestCreate for more details about the parameters';
params.classname = 'QUEST';
params.parentclassname = 'staircase';

if nargout>1
    qs = [];
    return;
end

if nargin<3 || isempty(debug)
    debug = 0;
end

[qs,parent] = readParameters(params,inputParams);

qs.q=QuestCreate(qs.tGuess,qs.tGuessSd,qs.pThreshold,...
    qs.beta,qs.delta,qs.gamma);

qs.q.normalizePdf=1;
%s.q_alltrials{k} = s.q{k};
%s.questSuccesses{k} = [];
%s.noiseVars{k} = [];

qs.questSuccesses = [];
qs.tTests = [];

qs = class(qs,'QUESTstaircase',staircase(parent,experiment,debug));