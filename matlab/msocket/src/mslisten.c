/************************************************************
 *
 * Name:   mslisten.c
 *
 * Author: Steven Michael (smichael@ll.mit.edu)
 *
 * Date:   5/19/06
 *
 * Description:
 *
 *    This is part of the "msocket" suite of TCP/IP 
 *    funcitons for MATLAB.  It is a wrapper for the
 *    "listen" socket function call.
 *
 * Copyright (c) 2006 MIT Lincoln Laboratory
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, 
 * Boston, MA  02110-1301  USA
 *
 ************************************************************/
#include <mex.h>
#include <string.h>

#if !defined(WIN32)
#ifdef _MAC_
#include <tcpd.h>
#endif
#include <sys/socket.h>
#include <unistd.h>
#include <sys/select.h>
#include <netdb.h>
#include <arpa/inet.h>
#define closesocket close
#else
#include <winsock2.h>
#endif


void mexFunction(int nlhs, mxArray *plhs[],
								 int nrhs, const mxArray *prhs[])
{
	int port;
	int *sock;
	int one = 1;
	struct sockaddr_in sin;
	char *hostname = (char *)0;

	plhs[0] = mxCreateNumericMatrix(1,1,mxINT32_CLASS,mxREAL);
	sock = (int *)mxGetPr(plhs[0]);
	sock[0] = -1;
	
	if(nrhs < 1) {
		mexPrintf("Must specify a port to listen on.\n");
		return;
	}
	if(!mxIsNumeric(prhs[0])) {
		mexPrintf("Must specify a port to listen on.\n");		
		return;
	}
	port = (int) mxGetScalar(prhs[0]);

	if(nrhs > 1) {
		if(!mxIsChar(prhs[1])) {
			mexPrintf("Second argument must be a host.\n");
			return;
		}
		hostname = mxArrayToString(prhs[1]);
	}

	if((sock[0] = (int) socket(AF_INET,SOCK_STREAM,0)) == -1) {
		perror("socket");
		return;
	}
	setsockopt(sock[0],SOL_SOCKET,SO_REUSEADDR,
						 (const char *)&one,sizeof(int));

	memset(&sin,0,sizeof(sin));
	sin.sin_family = AF_INET;
	if(!hostname) 
		sin.sin_addr.s_addr = INADDR_ANY;
	else {
		struct hostent *hp;
		if((hp = gethostbyname(hostname))==0)
			sin.sin_addr.s_addr = 
				((struct in_addr *)hp->h_addr)->s_addr;
		else
			sin.sin_addr.s_addr = inet_addr(hostname);
	}
	sin.sin_port = htons(port);

	if(bind(sock[0],(struct sockaddr *)&sin,sizeof(sin)) == -1) {
		perror("bind");
		closesocket(sock[0]);
		sock[0] = -1;
		return;
	}
	
	if(listen(sock[0],100)== -1) {
		perror("listen");
		closesocket(sock[0]);
		sock[0] = -1;
		return;
	}	

	return;
}
								 
