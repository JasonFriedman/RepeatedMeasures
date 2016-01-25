% PLAYANNOYINGBEEP - play an annoying beep (e.g. if did not move in time)
function playAnnoyingBeep(experimentdata)

%if ispc
%    wavplay(experimentdata.annoyingBeep,experimentdata.annoyingBeepf);
%else
    audioplayer(experimentdata.annoyingBeep,experimentdata.annoyingBeepf);
%end