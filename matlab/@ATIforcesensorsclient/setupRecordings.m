% SETUPRECORDINGS - Set the sample rate
%
% setupRecordings(fc,samplerate)
 
function setupRecordings(fc,samplerate)

codes = messagecodes;

m.command = codes.ATI_setupRecordings;
m.parameters = [];

sendmessage(fc,m,'setupRecordings');
