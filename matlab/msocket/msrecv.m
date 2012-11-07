% FUNCTION [var,success] = msrecv(sock,timeout)
% 
% Author: 
%   Steven Michael (smichael@ll.mit.edu)
%
% Description:
%
%    Receive a MATLAB variable "var" over socket "sock"
%
%    "sock" is a socket handle previously created with 
%    "msaccept" or "msconnect"
%
%    "var" is the returned variable, or empty in case of
%    failure
%
%    "timeout" is an optional second argument.  If passed in,
%    "msrecv" will return after "timeout" seconds if no
%    variable is received.  If "timeout" is not specified,
%    "msrecv" waits indefinetly
%
%    "success" is an optional success messages.  "success" < 0
%    indicates failure. "success" >= 0 indicates success.
%
% Example:
%    
%    This example has a client connect to a server and receive 
%    a variable 
%
%        Server Side             |       Client side
%                                |
% >> sendvar = 3;                |
% >> srvsock = mslisten(3000);   |
%                                |
%                                | >> sock = msconnect(server,3000);  
%                                |
% >> sock = msaccept(srvsock);   |
% >> msclose(srvsock);           |
% >> mssend(sock,sendvar);       | >> recvvar = msrecv(sock);
% >> msclose(sock);              | >> msclose(sock);
%
