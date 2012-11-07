/************************************************************
 *
 * Name:   mssendraw.c
 *
 * Author: Steven Michael (smichael@ll.mit.edu)
 *
 * Date:   5/19/06
 *
 * Description:
 *
 *    This is part of the "msocket" suite of TCP/IP 
 *    funcitons for MATLAB.  It is a wrapper for the
 *    "send" socket function call. The data will be sent
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
	int *ret;
	int sock;
	int len = -1;
	int cnt = 0;
	unsigned char *cdata;

	/* Allocate a return variable */
	plhs[0] = mxCreateNumericMatrix(1,1,mxINT32_CLASS,mxREAL);
	ret = (int *)mxGetPr(plhs[0]);
	ret[0] = -1;

	if(nrhs < 2) {
		mexPrintf("Must input a socket and a variable.\n");
		return;
	}
	if(!mxIsNumeric(prhs[0])) {
		mexPrintf("First argument must be a socket.\n");
		return;
	}

	if(!mxIsNumeric(prhs[1])) {
		mexPrintf("send variable must be numeric.\n");
		return;
	}

	/* Query the length to send */
	if(nrhs > 2) {
		if(!mxIsNumeric(prhs[2])) {
			mexPrintf("Length must be numeric.\n");
			return;
		}
		len = (int)mxGetScalar(prhs[2]);
		if(len < 0) return;
		if(len > (int) (mxGetNumberOfElements(prhs[1])*mxGetElementSize(prhs[1])))
			len = (int) (mxGetNumberOfElements(prhs[1])*mxGetElementSize(prhs[1]));
	}
	else 
		len = (int) (mxGetNumberOfElements(prhs[1])*mxGetElementSize(prhs[1]));

	sock = (int)mxGetScalar(prhs[0]);

	/* Send the string */
	cdata = (unsigned char *)mxGetPr(prhs[1]);
	while(cnt < len) {
		ret[0] = send(sock,cdata+cnt,len-cnt,0);
		if(ret[0] == -1) {
			perror("send");
			return;
		}
		cnt += ret[0];
	}

	return;
} /* end of mexFunction */
