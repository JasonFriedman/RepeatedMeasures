% TEXTARRAYSTIMULUS - class representing an array of text (e.g. asterisks)

function [v,params] = textArraystimulus(inputParams,experimentdata)

params.name = {'character','visualAngleHorizontal','rows','columns','positions','color'};
params.type = {'string','number','number','number','matrix_1_n','matrix_1_3'};
params.description = {'The character to draw in the array (e.g. ''*'')',...
    'The horizontal visual angle of the entire array (in degrees)',...
    'The number of rows','The number of columns',...
    'A 1 by n matrix with the locations of the characters to be shown in the array (first rows, then columns)',...
    'The color of the items in the array (RGB, each value from 0 to 255).'};
params.required = [1 0 0 0 1 0];
params.default = {'*',4.3,10,10,[],[255 255 255]};
params.classdescription = 'Draw ';
params.classname = 'textArraystimulus';
params.parentclassname = 'stimulus';

if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

v = class(v,'textArraystimulus',stimulus(parent));
