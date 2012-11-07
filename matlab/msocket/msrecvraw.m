% FUNCTION [rawdata,success] = msrecvraw(sock,len,timeout)
% 
% Author: 
%   Steven Michael (smichael@ll.mit.edu)
%
% Description:
%
%    Receive raw character data" over socket "sock"
%
%    "sock" is a socket handle previously created with 
%      "msaccept" or "msconnect"
%
%    "len" is the number of bytes to receive
%
%    "timeout" is an optional third argument.  If passed in,
%      "msrecv" will return after "timeout" seconds if no
%      variable is received.  If "timeout" is not specified,
%      "msrecv" waits indefinetly
%
%    "rawdata" is the raw unsigned 8 byte data
%
%    "success" is an optional success messages.  "success" < 0
%      indicates failure. "success" >= 0 indicates success.
%
