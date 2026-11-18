% IMREAD - Octave compatibility wrapper
% Octave returns a logical array for black and white images, MATLAB returns uint8
% (which is what RepeatedMeasures expects).
function [img,map,alpha] = imread(varargin)
here = fileparts(mfilename('fullpath'));
warnState = warning('off','all');
rmpath(here); % so that the call below reaches Octave's own imread
try
    [img,map,alpha] = imread(varargin{:});
catch err
    addpath(here);
    warning(warnState);
    rethrow(err);
end
addpath(here);
warning(warnState);
if islogical(img)
    img = uint8(img) * 255;
end
