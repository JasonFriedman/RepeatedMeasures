% MAKEBEEP - stub: generate a sine wave (same interface as the Psychtoolbox function)
function beepdata = MakeBeep(freq,duration,samplingRate)
if nargin<3 || isempty(samplingRate)
    samplingRate = 44100;
end
beepdata = sin(2*pi*freq*(0:round(duration*samplingRate))/samplingRate);
