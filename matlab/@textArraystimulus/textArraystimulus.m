% TEXTARRAYSTIMULUS - class representing an array of text (e.g. asterisks)

function [v,params] = textArraystimulus(inputParams,experimentdata)

params.name = {'character','visualAngleHorizontal','rows','columns','positions','color','x','y'};
params.type = {'string','number','number','number','matrix_1_n','matrix_1_3','string','string'};
params.description = {'The character to draw in the array (e.g. ''*'')',...
    'The horizontal visual angle of the entire array (in degrees)',...
    'The number of rows','The number of columns',...
    'A 1 by n matrix with the locations of the characters to be shown in the array (first rows, then columns)',...
    'The color of the items in the array (RGB, each value from 0 to 255).',...
    'x location of the array (either between 0 or 1, or ''center'' or ''right'')',...
    'y location of the array (either between 0 or 1, or ''center'')'};
params.required = [1 0 0 0 1 0 0 0];
params.default = {'*',4.3,10,10,[],[255 255 255],0,0};
params.classdescription = 'Draw ';
params.classname = 'textArraystimulus';
params.parentclassname = 'stimulus';

if nargout>1
    v = [];
    return;
end

[v,parent] = readParameters(params,inputParams);

if ~isnan(str2double(v.x))
    v.x = str2double(v.x);
end

if ~isnan(str2double(v.y))
    v.y = str2double(v.y);
end



v = class(v,'textArraystimulus',stimulus(parent));
