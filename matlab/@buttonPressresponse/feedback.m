% FEEDBACK - Provide feedback for button press
% This should not be run directly, it is called by runexperiment.m

function thistrial = feedback(r,e,thistrial,previoustrial,experimentdata,dataSummary,results)

firstpressed = dataSummary.firstpressed;
RT = dataSummary.RT;

thistrial = feedbackCommon(r,e,thistrial,RT,firstpressed,[r.leftButton r.rightButton],experimentdata);
