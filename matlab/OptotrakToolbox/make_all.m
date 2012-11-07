%This file allows you to compile the OptotrakToolbox on your system. 
%Please follow the instructions below...
%
%Copyright (C) 2004 Volker Franz, see README.txt and COPYING.txt.

%Uncomment the line with your operating system:
OS='Windows'
%OS='Linux'

%...and adapt the following path definitions to your local system:
if(strcmp(OS,'Windows'))
  %Windows:
  NDI_INCL  = '-I"C:\NDIoapi\ndlib\include"';
  NDI_LIB   = 'C:\NDIoapi\ndlib\msvc\oapi.lib';
  OPTO_UTIL = 'optoUtil.obj';
  echo on
  mex('-c',NDI_INCL,'optoUtil.c',NDI_LIB)
  mex(NDI_INCL,'optotrak.c',NDI_LIB,OPTO_UTIL)
  echo off
elseif(strcmp(OS,'Linux'))
  %Linux: 
%%todo:  setenv LD_LIBRARY_PATH '/home/vf/local/sources/optotrak_linux/lib/liboapi.a'
  NDI_INCL  = '-I"/home/vf/local/sources/optotrak_linux/ndlib/include"';
  NDI_LIB1  = '/home/vf/local/sources/optotrak_linux/lib/liboapi.a';
  NDI_LIB2  = '/home/vf/local/sources/optotrak_linux/lib/libndpak.a';
  OPTO_UTIL = 'optoUtil.o';
  echo on
  mex('-c',NDI_INCL,'optoUtil.c',NDI_LIB1,NDI_LIB2)
  mex(NDI_INCL,'optotrak.c',NDI_LIB1,NDI_LIB2,OPTO_UTIL)
  echo off
end
