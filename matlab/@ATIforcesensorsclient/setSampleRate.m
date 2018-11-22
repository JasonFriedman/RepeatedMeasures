% SETSAMPLERATE - Set the sample rate
%
% setSampleRate(fc,samplerate)
 
function setSampleRate(fc,samplerate)

codes = messagecodes;

m.command = codes.ATI_setSampleRate;
m.parameters = samplerate;

sendmessage(fc,m,'setSampleRate');
