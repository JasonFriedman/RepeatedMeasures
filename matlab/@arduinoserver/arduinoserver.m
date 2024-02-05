% ARDUINOSERVER - create an arduino server to listen for connections and sample
% from an arduino, or send signals (e.g. triggers)
% 
% This is designed to be used with the Matlab support package for Arduino
% Before use, you need to install the software on the arduino, using:
% arduinosetup
% 
%
% d = arduinoserver(port,maxsamplerate,arduinoPort,arduinoBoard,inputPins,outputPins,debug)
%
% The arduinoPort and arduinoBoard can be left off, and then the default
% will be used. See the arduino command for more details
%
% The inputPins and outputPins should be the pins for input and output
% (currently only digital), e.g. {'D2','D3'}
%
% e.g.
% d = arduinoserver(3010,500,[],[],{'D2'},{'D13'},0);
% or
% d = arduinoserver(3010,500,'com3','uno',{'D2'},{'D13'},0);

function d = arduinoserver(port,maxsamplerate,arduinoPort,arduinoBoard,inputPins,outputPins,debug)

if nargin<3 || isempty(arduinoPort)
    arduinoPort = [];
end

if nargin<4 || isempty(arduinoBoard)
    arduinoBoard = [];
end

if nargin<5 || isempty(inputPins)
    inputPins = {};
end

if nargin<6 || isempty(outputPins)
    outputPins = {};
end

if nargin<7 || isempty(debug)
    debug = 0;
end

if isempty(arduinoPort)
    d.arduino = arduino;
else
    d.arduino = arduino(arduinoPort, arduinoBoard);
end

d.inputPins = inputPins;
d.outputPins = outputPins;

d.codes = messagecodes;

d = class(d,'arduinoserver',socketserver(port,maxsamplerate,debug));