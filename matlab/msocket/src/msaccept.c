/************************************************************
 *
 * Name:   msaccept.c
 *
 * Author: Steven Michael (smichael@ll.mit.edu)
 *
 * Date:   5/19/06
 *
 * Description:
 *
 *    This is part of the "msocket" suite of TCP/IP 
 *    funcitons for MATLAB.  It is a wrapper for the
 *    "accept" socket function call.
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

#include <math.h>
#include <mex.h>
#if !defined(WIN32)
#ifdef _MAC_
#include <tcpd.h>
#endif
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <sys/select.h>
#include <netdb.h>
#include <arpa/inet.h>
#else
#include <winsock2.h>
#include "ws2tcpip.h"
#endif


void mexFunction(int nlhs, mxArray *plhs[],
								 int nrhs, const mxArray *prhs[])
{

	int lsock; 
	double timeout = -1;
	fd_set readfds,writefds,exceptfds;
	int asock=-1;

	
	if(nrhs < 1) {
		mexPrintf("Must specify a socket to listen on.\n");
		return;
	}
	if(!mxIsNumeric(prhs[0])) {
		mexPrintf("Must specify a port to listen on.\n");		
		return;
	}
	lsock = (int) mxGetScalar(prhs[0]);

	if(nrhs > 1) {
		if(!mxIsNumeric(prhs[1])) {
			mexPrintf("timeout must be numeric.\n");
			return;
		}
		timeout = mxGetScalar(prhs[1]);
	}
	
	FD_ZERO(&readfds);
	FD_ZERO(&writefds);
	FD_ZERO(&exceptfds);
	FD_SET(lsock,&readfds);
	FD_SET(lsock,&exceptfds);

	if(timeout >= 0) {
		struct timeval tv;
		tv.tv_sec = (int) timeout;
		tv.tv_usec = (int) (fmod(timeout,1) * 1.0E6);
		select(lsock+1,&readfds,&writefds,&exceptfds,&tv);
	}
	else
		select(lsock+1,&readfds,&writefds,&exceptfds,(struct timeval *)0);
	
	if(FD_ISSET(lsock,&readfds)) {
		struct sockaddr_in pin;
		int addrlen = sizeof(struct sockaddr_in);
#if !defined(WIN32)
		asock = (int) accept(lsock,(struct sockaddr *)&pin,
												 (socklen_t *)&addrlen);
#else
		asock = (int) accept(lsock,(struct sockaddr *)&pin,
											 (int *)&addrlen);
#endif
		if(nlhs > 1) 
			plhs[1] = mxCreateString(inet_ntoa(pin.sin_addr));
		if(nlhs > 2) {
			char hname[256];
			getnameinfo((struct sockaddr *)&pin,sizeof(struct sockaddr_in),
									hname,256,NULL,0,0);
			plhs[2] = mxCreateString(hname);
		}
	}
	else {
		if(nlhs > 1) 
			plhs[1] = mxCreateNumericMatrix(0,0,mxDOUBLE_CLASS,mxREAL);
		if(nlhs > 2)
			plhs[2] = mxCreateNumericMatrix(0,0,mxDOUBLE_CLASS,mxREAL);
	}
	
	plhs[0] = mxCreateNumericMatrix(1,1,mxINT32_CLASS,mxREAL);
	((int *)mxGetPr(plhs[0]))[0] = asock;
	return;
} /* end of msaccept */
								 
