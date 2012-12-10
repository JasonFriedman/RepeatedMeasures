% compile code

% Check which version of the SDK is installed
%if exist('C:\Program Files\CyberGlove Systems\VirtualHand SDK\','dir')
%    mex -v Glove_Rendering.cpp  -I"C:\Program Files\CyberGlove Systems\VirtualHand SDK\include" -I"C:\Program Files\CyberGlove Systems\VirtualHand SDK\include\vhandtk" -L"C:\Program Files\CyberGlove Systems\VirtualHand SDK\lib\winnt_386\Release" -L"C:\Program Files\CyberGlove Systems\VirtualHand SDK\lib\winnt_386\Unsupported" -lCGS_VirtualHandCore -lCGS_VirtualHandDevice -lglut32 
%else

% For 64-bit only the new version will work
if strcmp(mexext,'mexw64')
    mex -v Glove_Rendering.cpp -DGLUT_NO_LIB_PRAGMA -I"C:\Program Files\CyberGlove Systems\VirtualHand SDK\include" -I"C:\Program Files\CyberGlove Systems\VirtualHand SDK\include\vhandtk" -L"C:\Program Files\CyberGlove Systems\VirtualHand SDK\lib\winnt_x64\Release" -L"C:\Program Files\CyberGlove Systems\VirtualHand SDK\lib\winnt_x64\Unsupported" -lglut64 -lOpenGL32 -lCGS_VirtualHandCore -lCGS_VirtualHandDevice  
elseif exist('C:\Program Files (x86)\Immersion Corporation','dir')
    mex -v Glove_Rendering.cpp -DOLD_VHT -I"C:\Program Files (x86)\Immersion Corporation\VirtualHand\Development\include" -L"C:\Program Files (x86)\Immersion Corporation\VirtualHand\Development\lib\winnt_386"  -lVirtualHandCore -lVirtualHandDevice -lglut32 -llibdemoBase 
else
    mex -v Glove_Rendering.cpp -DOLD_VHT -I"C:\Program Files\Immersion Corporation\VirtualHand\Development\include" -L"C:\Program Files\Immersion Corporation\VirtualHand\Development\lib\winnt_386"  -lVirtualHandCore -lVirtualHandDevice -lglut32 -llibdemoBase 
end
%