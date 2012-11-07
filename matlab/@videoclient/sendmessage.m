% SENDMESSAGE - Send a message to the video server
% Generally, don't call this directly. Rather use programs such as recordVideo
%
% sendmessage(vc,message,arg1,filename,name)
%
% This replaces the sendmessage in the superclass, because we are
% communicating with a c++ program and not a matlab one, so need to use
% more basic socket communications without the msocket layer
%
% name is the name of the message (only needed if in debug mode)

function sendmessage(vc,message,arg1,filename,name)

if nargin<4
    filename = '';
end

num = sprintf('%03d',arg1);

success = mssendraw(get(vc,'sock'),uint8([message num filename 0]));

if get(vc,'debug');
    fprintf('Sent %s, returned %d\n',name,success);
end
