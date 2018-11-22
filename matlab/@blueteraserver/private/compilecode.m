% compile code

if strcmp(mexext,'mexw32')
    mex -v blueTeraMex.cpp -I"d:\software\IOTera_SDK_v0.1\C++\include" -L"d:\software\IOTera_SDK_v0.1\C++\bin\x86\" -lioterasdk
elseif strcmp(mexext,'mexw64')
    % Use -g helps with debugging when it crashes
    mex -g -v blueTeraMex.cpp -I"d:\software\IOTera_SDK_v0.1\C++\include" -L"d:\software\IOTera_SDK_v0.1\C++\bin\x64\" -lioterasdk
    %mex -v blueTeraMex.cpp -I"d:\software\IOTera_SDK_v0.1\C++\include" -L"d:\software\IOTera_SDK_v0.1\C++\bin\x64\" -lioterasdk
else
    error('Unsupported architecture');
end