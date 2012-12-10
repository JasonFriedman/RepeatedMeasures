% NEEDSSAMPLINGWHENNOTRECORDING - does this response need sampling to take place when not recording
%
% The keyboardsequence needs to read the keys to check if the sequence is finished, so if not
% recording, then sampling without recording is necessary

function answer = needsSamplingWhenNotRecording(r)

answer = 1;
