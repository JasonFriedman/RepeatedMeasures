% GENERATEPROTOCOLS - generate all the sample protocols described in the paper
%
% generateProtocols

if ~exist('protocols','dir')
    mkdir('protocols');
end

generateMaleFemaleProtocol;
generateMouseWordsProtocol;
generateRDKProtocol;
%generateMaskedPrimingProtocol;
generateNCEProtocol;
generateQuestImagesProtocol;
generateCopyShapesProtocol;
generateCopyMovementsProtocol;
generateRecordVideoProtocol;
generateShowHandProtocol;
generateSequenceLearningProtocol;
generateTMSTriggerProtocol;