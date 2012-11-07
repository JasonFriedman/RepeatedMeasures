////////////////////////////////////////////////////////////
//
// Name:   mssend.cpp
//
// Author: Steven Michael (smichael@ll.mit.edu)
//
// Date:   5/19/06
//
// Description:
//
//    This is part of the "msocket" suite of TCP/IP 
//    funcitons for MATLAB.  It is a wrapper for the
//    "send" socket function call. The data send is a serialized
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
	int *ret;
	int sock;
	
	if(nrhs < 2) {
		mexPrintf("Must input a socket and a variable.\n");
		return;
	}
	if(!mxIsNumeric(prhs[0])) {
		mexPrintf("First argument must be a socket.\n");
		return;
	}

	sock = (int)mxGetScalar(prhs[0]);

	plhs[0] = mxCreateNumericMatrix(1,1,mxINT32_CLASS,mxREAL);
	ret = (int *)mxGetPr(plhs[0]);
	
	MatVar mv;
	mv.create(prhs[1]);
	int mvlen = mv.get_serialize_length();
	int smvlen = mvlen;
	
#ifdef _BIG_ENDIAN_
	unsigned char *tmp = (unsigned char *)&smvlen;
	unsigned char t;
	t = tmp[0];tmp[0] = tmp[3];tmp[3] = t;
	t = tmp[1];tmp[1] = tmp[2];tmp[2] = t;
#endif
	ret[0] = ::send(sock,(const char *)&smvlen,sizeof(int),0);
	if(ret[0] == -1) {
		perror("send");
		return;
	}

	int cnt = 0;
	char *cdata = new char[mvlen];
	mv.serialize(cdata);
	while(cnt < mvlen) {
		ret[0] = ::send(sock,cdata+cnt,mvlen-cnt,0);
		if(ret[0] == -1) {
			perror("send");
			delete[] cdata;
			return;
		}
		cnt += ret[0];
	}
	delete[] cdata;
	return;
} // end of mexFunction
