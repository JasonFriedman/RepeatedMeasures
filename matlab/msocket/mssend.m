% FUNCTION success = mssend(sock,var)
%
% Author: 
%   Steven Michael (smichael@ll.mit.edu)
%
% Description:
%
%    Send a MATLAB variable "var" over socket "sock"
%
%    "sock" is a socket handle previously created with 
%    "msaccept" or "msconnect"
%
%    "var" is any MATLAB variable.  Currently, all variable
%    types are supported except for function handles.
%
%    "success" is a status indicator. "success" < 0 indicates failure.
%    Any other number indicates success.
%
% Example:
%    
%    This example has a client connect to a server and receive 
%    a variable over port 3000
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

