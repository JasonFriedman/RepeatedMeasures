% POSTTRIAL - do anything that needs to be done post-trial
% For images, close the textures

function [thistrial,experimentdata] = postTrial(s,dataSummary,thistrial,experimentdata)

Screen('Close',thistrial.textures); % Close any textures to save memory
