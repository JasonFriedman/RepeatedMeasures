/************************************************************
 *
 * Name:   msclose.c
 *
 * Author: Steven Michael (smichael@ll.mit.edu)
 *
 * Date:   5/19/06
 *
 * Description:
 *
 *    This is part of the "msocket" suite of TCP/IP 
 *    funcitons for MATLAB.  It is a wrapper for the
 *    "close" socket function call.
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
  int sock = -1;
	if(prhs < 0)
		return;
	
	if(!mxIsNumeric(prhs[0]))
		return;

	sock = (int) mxGetScalar(prhs[0]);
	if(sock==-1)
		return;

#if !defined(WIN32)
	if(shutdown(sock,SHUT_RDWR))
		perror("shutdown");
	if(close(sock))
		perror("close");
#else
	if(shutdown(sock,SD_BOTH))
		perror("shutdown");
	if(closesocket(sock))
		perror("close");
#endif
	return;
} /* end of mexFunction */
