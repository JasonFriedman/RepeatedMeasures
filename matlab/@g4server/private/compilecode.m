% compile code

if strcmp(mexext,'mexw64');
    mex -v G4Mex.cpp -I"c:\Program Files (x86)\Polhemus\PDI\PDI_110\Inc" -L"c:\Program Files (x86)\Polhemus\PDI\PDI_110\Lib\x64\" -lPDI
else
    error('Unsupported architecture');
end