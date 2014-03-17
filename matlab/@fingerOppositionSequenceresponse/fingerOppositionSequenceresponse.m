% FINGEROPPOSITIONSEQUENCERESPONSE - class representing "finger opposition" sequence response
% (i.e. you need to press touch the thumb and a certain finger in a certain order

function [r,params] = fingerOppositionSequenceresponse(inputParams)

params.name = {'sequence','repetitions','fingermarkers','touchThreshold','untouchThreshold','fingertipdistance'};
params.type = {'matrix','number','matrix','number','number','number'};
params.description = {'The sequence to be performed (e.g. [4 1 2 3 4])','The number of repetitions to be performed to complete the trial',...
    'The markers which are the fingertips, first the thumb, then index, etc (e.g. [6 7 8 9 10])','threshold below which fingers are considered touching','threshold above which fingers are no longer touching','distance from the marker to the respective fingertip'};
params.required = [1 1 1 0 0 0];
params.default = {[],1,[6 7 8 9 10],2,3,2};
params.classdescription = 'The response is touching the thumb and another finger in a sequence N times';
params.classname = 'fingerOppositionSequenceresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'fingerOppositionSequenceresponse',response(parent));

if any(r.sequence>4)
    r.sequence
    error('The sequence must be a matrix made of integers between 1 and 4');
end

