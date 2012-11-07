% Function [sconnect,hostip,hostname] = msaccept(sock,timeout)
% 
% Author: 
%   Steven Michael (smichael@ll.mit.edu)
%
% Description:
%
%    This function accepts connections on "sock", a 
%    a function handle previously created with "mslisten"
%
%    "timeout" is an optional second argument.  If passed in, 
%    "msaccept" will return after "timeout" seconds if no 
%    connection is made, and "sconnect" will be invalid.  If "timeout"
%    is not specified, "msaccept" waits indefinetly.
%
%
%    "hostip" and "hostname" are the ip address and hostname, respectively,
%     of the remote host.
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
