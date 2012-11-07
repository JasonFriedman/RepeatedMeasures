% READAUDIOFILEDETAILS - read the details of audio files (wav) to be played in this trial (if any)

function thistrial = readAudioFileDetails(thistrial,experimentdata,validating)

if ~isempty(thistrial.playAudioFile) && ~iscell(thistrial.playAudioFile)
    tmp = thistrial.playAudioFile;
    thistrial = rmfield(thistrial,'playAudioFile');
    thistrial.playAudioFile{1} = tmp;
end
for k=1:numel(thistrial.playAudioFile)
    number = thistrial.playAudioFile{k}.number;
    if number > numel(experimentdata.sounds)
        error(['There are not enough wav files specified (a trial asks for .wav file number ' num2str(number) ')']);
    end
    thistrial.playAudioFile{k}.started = 0;
end
