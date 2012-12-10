% SETSAMPLERATE - set the sample rate
% 
% setsamplerate(lc)
%
% samplerate is a parameter of libertyclient, and can be 120Hz or 240Hz

function setsamplerate(lc)

if lc.samplerate==120
    code = 3;
elseif lc.samplerate==240
    code = 4;
else
    error('Sample rate must be 120 Hz or 240 Hz');
end

codes = messagecodes;

m.command = codes.LIBERTY_SetSampleRate;
m.parameters = code;

sendmessage(lc,m,'SetSampleRate');
