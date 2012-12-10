% compile the mex file

%mex GloveMex.cpp ../../VirtualHumanHand/CyberGloveWithCalibration.cpp ../../VirtualHumanHand/GloveWithCalibration.cpp ../../VirtualHumanHand/DCUCalibrationData.cpp ../../VirtualHumanHand/GloveParam.cpp -I"../../VirtualHumanHand" -I"C:\Program Files\Immersion Corporation\VirtualHand\Development\include" -L"C:\Program Files\Immersion Corporation\VirtualHand\Development\lib\winnt_386"  VirtualHandCore.lib VirtualHandDevice.lib
mex GloveMex.cpp -I"C:\Program Files\Immersion Corporation\VirtualHand\Development\include" -L"C:\Program Files\Immersion Corporation\VirtualHand\Development\lib\winnt_386"  VirtualHandCore.lib VirtualHandDevice.lib
