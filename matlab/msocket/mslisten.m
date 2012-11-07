% FUNCTION sock = mslisten(port)
% 
% Author: 
%   Steven Michael (smichael@ll.mit.edu)
%
% Description:
%
%    This function returns the handle to a socket that is listening
%    for connections on the input port.  Only TCP/IP connecitons are
%    currently supported. On error, -1 is returned.
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
