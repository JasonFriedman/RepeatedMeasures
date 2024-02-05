% RUNARDUINOSERVER - run an arduino server for digital input/output on port 3010 in another matlab process
%
function runarduinoserver(arduinoPort,arduinoBoard,inputPins,outputPins)

if nargin<1 || isempty(arduinoPort)
    arduinoPort = [];
end

if nargin<2 || isempty(arduinoBoard)
    arduinoBoard = [];
end

if nargin<3 || isempty(inputPins)
    inputPins = {};
elseif ~iscell(inputPins)
    inputPins = {inputPins};
end

if nargin<4 || isempty(outputPins)
    outputPins = {};
elseif ~iscell(outputPins)
    outputPins = {outputPins};
end

if isempty(inputPins) && isempty(outputPins)
    error('There are no input pins or output pins defined!');
end

inputPinsString = '{';
for k=1:numel(inputPins)
    inputPinsString = [inputPinsString '''' inputPins{k} ''''];
    if k<numel(inputPins)
        inputPinsString = [inputPinsString ','];
    end
end
inputPinsString = [inputPinsString '}'];

outputPinsString = '{';
for k=1:numel(outputPins)
    outputPinsString = [outputPinsString '''' outputPins{k} ''''];
    if k<numel(outputPins)
        outputPinsString = [outputPinsString ','];
    end
end
outputPinsString = [outputPinsString '}'];

debug = 1;

if isempty(arduinoPort)
    arduinoPort = '[]';
end
if isempty(arduinoBoard)
    arduinoBoard = '[]';
end

runstring = sprintf('matlab -nojvm -r "d = arduinoserver(3010,500,%s,%s,%s,%s,%d);listen(d)" &',...
        arduinoPort,arduinoBoard,inputPinsString,outputPinsString,debug);

runstring

system(runstring);