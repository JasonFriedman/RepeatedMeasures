% FUNCTION success = mssendraw(sock,uint8data)
%
% Author: 
%   Steven Michael (smichael@ll.mit.edu)
%
% Description:
%
%    Send raw byte data "uint8data"  over socket "sock"
%
%    "sock" is a socket handle previously created with 
%    "msaccept" or "msconnect"
%
%    "uint8data" is an array of unsigned bytes.  This is
%      the data that is sent.
%
%    "success" is a status indicator. "success" < 0 indicates failure.
%      Any other number indicates success.
%
%
% Example:
%
%   sock = msconnect('hostname',port)
%   success = mssendraw(sock,uint8('string to send'));
%
