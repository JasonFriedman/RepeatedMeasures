/************************************************************
 *
 * Name:   msrecvraw.c
 *
 * Author: Steven Michael (smichael@ll.mit.edu)
 *
 * Date:   5/19/06
 *
 * Description:
 *
 *    This is part of the "msocket" suite of TCP/IP 
 *    funcitons for MATLAB.  It is a wrapper for the
 *    "recv" socket function call. The data will be received
 *    as a MATLAB array of unsigned 8 bit integers.
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
#include <math.h>


#if !defined(WIN32)
#include <sys/socket.h>
#include <unistd.h>
#include <sys/select.h>
#include <netdb.h>
#include <arpa/inet.h>
#else
#include <winsock2.h>
#endif

void mexFunction(int nlhs, mxArray *plhs[],
								 int nrhs, const mxArray *prhs[])
{
	int sock = -1;
	int recvlen = -1;
	int cnt = 0;
	int ret;
	char *cdata = (char *)0;
	double timeout = -1;
	fd_set readfds,writefds,exceptfds;

	if(nrhs < 2) {
		mexPrintf("Must input a socket and a length\n");
		return;
	}
	if(!mxIsNumeric(prhs[0]) || !mxIsNumeric(prhs[1])) {
		mexPrintf("Invalid arguments.\n");
		return;
	}
	if(nrhs > 2) {
		if(!mxIsNumeric(prhs[2])) {
			mexPrintf("3rd argument (timeout in s) must be numeric.\n");
			return;
		}
		timeout = mxGetScalar(prhs[2]);
	}

	sock = (int)mxGetScalar(prhs[0]);
	recvlen = (int) mxGetScalar(prhs[1]);

	plhs[0] = mxCreateNumericMatrix(recvlen,1,mxUINT8_CLASS,mxREAL);
	cdata =  (char *)mxGetPr(plhs[0]);

	while(cnt < recvlen) {
		FD_ZERO(&readfds);
		FD_ZERO(&writefds);
		FD_ZERO(&exceptfds);
		FD_SET(sock,&readfds);
		FD_SET(sock,&exceptfds);

		if(timeout < 0)
			select(sock+1,&readfds,&writefds,&exceptfds,(struct timeval *)0);
		else {
			struct timeval tv;
			tv.tv_sec = (int) timeout;
			tv.tv_usec = (int) (fmod(timeout,1.0)*1.0E6);
			select(sock+1,&readfds,&writefds,&exceptfds,&tv);
		}
		if(FD_ISSET(sock,&readfds)==0) {
			plhs[0] = mxCreateNumericMatrix(0,0,mxCHAR_CLASS,mxREAL);
			if(nlhs > 1)
				plhs[1] = mxCreateScalarDouble(-1.0f);
			return;
			mxFree(cdata);
		}
		
		ret = recv(sock,cdata+cnt,recvlen-cnt,0);
		if(ret == -1) {
			cdata[0] = '\0';
			if(nlhs > 1)
				plhs[1] = mxCreateScalarDouble(-1.0);
			return;
		}
		cnt += ret;
	} /* end of while */
	
	if(nlhs > 1)
		plhs[1] = mxCreateScalarDouble(0.0);
		
	return;
} /* end of mexFunction */
