% FEEDBACK - Provide feedback for keyboard
% This should not be run directly, it is called by runexperiment.m

function thistrial = feedback(r,e,thistrial,previoustrial,experimentdata,dataSummary)

if isfield(dataSummary,'kb_firstpressed')
    firstpressed = dataSummary.kb_firstpressed;
    RT = dataSummary.kb_RT;
    thistrial = feedbackCommon(r,e,thistrial,RT,firstpressed,r.keytopress,experimentdata);
elseif isfield(thistrial,'kb_firstpressed')
    firstpressed = thistrial.kb_firstpressed;
    thistrial = feedbackCommon(r,e,thistrial,NaN,firstpressed,r.keytopress,experimentdata);
end
