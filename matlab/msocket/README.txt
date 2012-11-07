MSOCKET

Author: Steven Michael (smichael@ll.mit.edu)
Date:   5/19/06

Description:

Copyright 2006 MIT Lincoln Laboratory 
Released under the GNU LGPL.  See lgpl.txt in this directory

This is a suite of tools that allow TCP/IP socket communication via MATLAB.
In particular, the tools allow for easy communication of MATLAB variables
between networked MATLAB sessions via the "mssend" and "msrecv" functions. 
All variable types, including strutures and cells, are supported.  

The socket communication is done via compiled C and C++ mex files that make
the standard socket calls.  Big-Endian / Little-Endian switching
is supported via a flag in the Makefile.

"mssendraw" and "msrecvraw" are also included.  These allow for sending
and receiving raw character data over the socket.  They are not well tested. 

Binaries are included for x86 Linux and windows.  Compiling for other 
systems should be simple, as the socket calls are standard over different
operating systems.  

The "winmake" directory includes Microsoft Visual Studio 2005 project
files for compiling the windows libraries.

The source is setup to compile under the MAC or solaris platforms 
with endian switching to allow for communication between machines
with different endian types.  This has been verified to work. When
compiling on big-endian platforms (MAC, Solaris) make sure the 
compiler includes the compile flag "-D_BIG_ENDIAN_" to turn on the 
endian switching.

Note: the Windows files with the ".mexw32" extension may have to be 
renamed to a ".dll" extension to work with versions of MATLAB older than
R14 service pack 3.

Note: under windows, the files are compiled with the Microsoft Visual 
Studio 8.0 compilers.  This may require installation of the Visual Studio
runtime libraries. These are included with MATLAB under:
$MATLAB/bin/win32/vcredist_x86.exe
See: http://www.mathworks.com/support/solutions/data/1-2223MW.html 

Example:    

    This example has a client connect to a server and receive 
    a variable 

        Server Side             |       Client side
                                |
 >> sendvar = 3;                |
 >> srvsock = mslisten(3000);   |
                                |
                                | >> sock = msconnect(server,3000);  
                                |
 >> sock = msaccept(srvsock);   |
 >> msclose(srvsock);           |
 >> mssend(sock,sendvar);       | >> recvvar = msrecv(sock);
 >> msclose(sock);              | >> msclose(sock);




Changes:

3/31/08
  1. Compile with 2008a
	2. Use Visual Studio Express 2008 (free download)
	     for Windows compile

8/15/07
  1. Compile with v2007a 
  2. Fix to accomodate new "mwSize" data type in mex.h
  3. Streamline Visual Studio 2005 compile environment 

7/24/06
  1. Fix the mssendraw and mssrecvraw functions.
     These are now verified to work.
     (mssendraw now sends only uint8 data types)
  2. Release under the GNU LGPL
	3. include MATLAB functions "compileit.m" and
     "compileit_windows.m" to facilitate compiling
     under MATLAB.

5/23/06
  1. Fix the big endian / little endian switching
     (now works correctly on MAC)
  2. Include binaries for MAC and x86_64 systems in
     addition to Windows and Linux x86
