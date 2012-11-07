% RECORDVIDEO - record a video
%
% recordVideo(vc,videoLength,filename)
%
% videoLength is in seconds

function recordVideo(vc,videoLength,filename)

codes = messagecodes;
sendmessage(vc,codes.rvRecordVideo,videoLength,[filename '.avi'],'recordVideo');
