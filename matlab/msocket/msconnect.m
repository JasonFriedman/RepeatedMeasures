% FUNCTION sock = msconnect(hotname,port)
% 
% Author: 
%   Steven Michael (smichael@ll.mit.edu)
%
% Description:
% 
%    This function makes a TCP/IP socket connection to 
%    "hostname" on port "port"
% 
%    On success, a socket handle "sock" is returned.
%    On failure, "sock is set to -1;
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
