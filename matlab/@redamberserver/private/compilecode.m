% compile code

if strcmp(mexext,'mexw32')
    mex -v redamberMex.cpp -I"d:\software\GemSDK.Windows\include" -L"d:\software\GemSDK.Windows\bin\x86\" -lGemSDK
elseif strcmp(mexext,'mexw64')
    mex -v redamberMex.cpp -I"d:\software\GemSDK.Windows\include" -L"d:\software\GemSDK.Windows\bin\x64\" -lGemSDK
else
    error('Unsupported architecture');
end