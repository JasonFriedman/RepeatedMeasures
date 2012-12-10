% COMPILECODE - recompile the mex file

if strcmp(mexext,'mexw64')
    mex -v FastrakMex.cpp -I"C:\Program Files\CyberGlove Systems\VirtualHand SDK\include" -I"C:\Program Files\CyberGlove Systems\VirtualHand SDK\include\vhandtk" -L"C:\Program Files\CyberGlove Systems\VirtualHand SDK\lib\winnt_x64\Release" -lCGS_VirtualHandCore -lCGS_VirtualHandDevice  
else
    mex -v FastrakMex.cpp  -I"C:\Program Files\Immersion Corporation\VirtualHand\Development\include" -L"C:\Program Files\Immersion Corporation\VirtualHand\Development\lib\winnt_386"  VirtualHandCore.lib VirtualHandDevice.lib glut32.lib libdemoBase.lib 
end