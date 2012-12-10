% FEEDBACK - Provide feedback for button press
% This should not be run directly, it is called by runexperiment.m

function thistrial = feedback(r,e,thistrial,previoustrial,experimentdata,dataSummary)

LEFT = 1; RIGHT = 3;
firstpressed = dataSummary.firstpressed;
RT = dataSummary.RT;

thistrial = feedbackCommon(r,e,thistrial,RT,firstpressed,LEFT,RIGHT,experimentdata);
