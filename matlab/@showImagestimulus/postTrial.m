% POSTTRIAL - do anything that needs to be done post-trial
% For images, close the textures

function [thistrial,experimentdata] = postTrial(s,dataSummary,thistrial,experimentdata,e)

Screen('Close',thistrial.textureIndex); % Close the textures used to save memory
