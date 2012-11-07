% compile code

 mex -v Glove_Rendering.cpp  -I"C:\Program Files\Immersion Corporation\VirtualHand\Development\include" -L"C:\Program Files\Immersion Corporation\VirtualHand\Development\lib\winnt_386"  VirtualHandCore.lib VirtualHandDevice.lib glut32.lib libdemoBase.lib 

%   mex -g -v Glove_RenderingWithCalibration.cpp OglDrawerWithCalibration.cpp HumanHandWithCalibration.cpp GloveWithCalibration.cpp CyberGloveEmulatorWithCalibration.cpp utils.cpp matrixtools.cpp DCUCalibrationData.cpp GloveParam.cpp -I"C:\Program Files\Immersion Corporation\VirtualHand\Development\include" -L"C:\Program Files\Immersion Corporation\VirtualHand\Development\lib\winnt_386"  VirtualHandCore.lib VirtualHandDevice.lib glut32.lib libdemoBase.lib 
