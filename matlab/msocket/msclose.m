% FUNCTION msclose(sock)
% 
% Author: 
%   Steven Michael (smichael@ll.mit.edu)
%
% Description:
%
%    This function closes a socket handle previously
%    opened with "mslisten", "msconnect", or "msaccept"
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
