////////////////////////////////////////////////////////////
//
// Name:   msrecv.cpp
//
// Author: Steven Michael (smichael@ll.mit.edu)
//
// Date:   5/19/06
//
// Description:
//
//    This is part of the "msocket" suite of TCP/IP 
//    funcitons for MATLAB.  It is a wrapper for the
//    "recv" socket function call. The data send is a serialized
//    MALTAB variable in a format described by matvar.cpp
//
// Copyright (c) 2006 MIT Lincoln Laboratory
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, 
// Boston, MA  02110-1301  USA
//
////////////////////////////////////////////////////////////

#include <mex.h>
#include <math.h>

#include <matvar.h>

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
	int recvlen;
	int ret;
	char *cdata = (char *)0;
	MatVar mv;
	int cnt;
	double timeout = -1;
	fd_set readfds,writefds,exceptfds;

	if(nrhs < 1) {
		mexPrintf("Must input a socket\n");
		return;
	}
	if(!mxIsNumeric(prhs[0])) {
		mexPrintf("First argument must be a socket.\n");
		return;
	}
	if(nrhs > 1) {
		if(!mxIsNumeric(prhs[1])) {
			mexPrintf("2nd argument (timeout in s) must be numeric.\n");
			return;
		}
		timeout = mxGetScalar(prhs[1]);
	}

	sock = (int)mxGetScalar(prhs[0]);

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
		plhs[0] = mxCreateNumericMatrix(0,0,mxDOUBLE_CLASS,mxREAL);
		if(nlhs > 1)
			plhs[1] = mxCreateScalarDouble(-1.0f);
		return;
	}

	// Receive the count
	cnt = 0;
	while (cnt < (int) sizeof(int)) {
		ret = ::recv(sock,((char *)&recvlen)+cnt,
					sizeof(int)-cnt,0);
		
		if(ret == -1) {
			perror("recv");
			plhs[0] = mxCreateNumericMatrix(0,0,mxDOUBLE_CLASS,mxREAL);
			if(nlhs > 1)
				plhs[1] = mxCreateScalarDouble(-1.0f);
			return;
		}
		cnt += ret;
	}
#ifdef _BIG_ENDIAN_
    unsigned char *tmp = (unsigned char *)&recvlen;
    unsigned char t;
    t = tmp[0];tmp[0] = tmp[3];tmp[3] = t;
    t = tmp[1];tmp[1] = tmp[2];tmp[2] = t;
#endif
	if(recvlen <= 0) {
		plhs[0] = mxCreateNumericMatrix(0,0,mxDOUBLE_CLASS,mxREAL);
		if(nlhs > 1)
			plhs[1] = mxCreateScalarDouble(-1.0);
		return;
	}
	// Receive the array
	cdata = new char[recvlen];
	cnt = 0;
	while(cnt < recvlen) {
		ret = recv(sock,(cdata+cnt),recvlen-cnt,0);
		if(ret == -1) {
			delete[] cdata;
			perror("recv");
			plhs[0] = mxCreateNumericMatrix(0,0,mxDOUBLE_CLASS,mxREAL);
			if(nlhs > 1)
				plhs[1] = mxCreateScalarDouble(-1.0);
			return;
		}
		cnt += ret;
	}
	
	mv.create((void *)cdata);
	plhs[0] = mv.get_mxarray();
	if(nlhs > 1)
		plhs[1] = mxCreateScalarDouble(0.0);
	if(cdata) delete[] cdata;
		
	return;
} // end of mexFunction
