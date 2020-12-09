% startRecording - stop recording from the ATI force sensors

function f = stopRecording(f)

f.v.stopStreamingData;

% read any last samples 
n = f.v.readStreamingSamples;
