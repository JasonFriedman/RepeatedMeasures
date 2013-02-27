% compile code

if strcmp(mexext,'mexw32')
        mex -v LibertyMex.cpp -I"C:\Program Files (x86)\Polhemus\PDI\PDI_100\Inc" -L"C:\Program Files (x86)\Polhemus\PDI\PDI_100\lib\Win32\" -lPDI
elseif strcmp(mexext,'mexw64');
    mex -v LibertyMex.cpp -I"C:\Program Files (x86)\Polhemus\PDI\PDI_100\Inc" -L"C:\Program Files (x86)\Polhemus\PDI\PDI_100\lib\x64\" -lPDI
else
    error('Unsupported architecture');
end