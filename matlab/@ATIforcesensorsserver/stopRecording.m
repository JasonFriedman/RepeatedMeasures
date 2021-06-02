% startRecording - stop recording from the ATI force sensors

function f = stopRecording(f)

f.v.stopStreamingData;

% read any last samples
try % prevent crashing from socket timeout
    n = f.v.readStreamingSamples;
catch E
    fprintf('Caught error: %s\n', getReport(E));
end
