% SYMBOLSSTIMULUS - class representing "symbols" stimulus (i.e. arbitrary text)

function [v,params] = symbolsstimulus(inputParams,experimentdata)

params.name = {'stimuli'};
params.type = {'matrix_n_3'};
params.description = {'An n x 3 matrix. The first column is which symbol to show. The second is the frame to start showing that symbol. The third is the frame to stop showing that symbol. A 0 in the first column indicates no symbol'};
params.required = 1;
params.default = {[]};
params.classdescription = 'Present some symbols (i.e. arbitrary text) at specified times';
params.classname = 'symbolsstimulus';
params.parentclassname = 'stimulus';

if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

if numel(experimentdata.symbols) < max(v.stimuli(:,1))
    error(['There are no enough symbols specified in the setup.symbols, there must be at least ' num2str(max(v.stimuli(:,1)))]);
end

v = class(v,'symbolsstimulus',stimulus(parent));
