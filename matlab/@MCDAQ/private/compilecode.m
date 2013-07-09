% compile the mex file

if strcmp(mexext,'mexw64')
    mex MCDAQMex.cpp -I"C:\Users\Public\Documents\Measurement Computing\DAQ\C" -L"C:\Users\Public\Documents\Measurement Computing\DAQ\C" -lcbw64
elseif strcmp(mexext,'mexw32')
    mex MCDAQMex.cpp -I"C:\Users\Public\Documents\Measurement Computing\DAQ\C" -L"C:\Users\Public\Documents\Measurement Computing\DAQ\C" -lcbw32
else
    error('Using the MC DAQ with the Universal Library is only supported in Windows');
end