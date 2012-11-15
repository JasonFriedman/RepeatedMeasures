% GENERATEPROTOCOLS - generate all the sample protocols described in the paper
%
% generateProtocols

if ~exist('protocols','dir')
    mkdir('protocols');
end

generateMaleFemaleProtocol;
generateMouseWordsProtocol;
generateCopyShapesProtocol;
generateCopyMovementsProtocol;
generateRecordVideoProtocol;
generateShowHandProtocol;
generateLibertyImagesProtocol;
generateRecordVideoProtocol;
