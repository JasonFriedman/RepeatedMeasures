% CREATEHAND - create the virtual hand
% Requires the virtualhand SDK be installed

function createHand(gtc)

if ~gtc.noVHT
    Glove_Rendering(0);  
end