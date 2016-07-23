function runserialportserver(COMport,baudRate,samplerate)
% RUNSERIALPORTSERVER - run the serial port server with standard settings
% runserialportserver(COMport,baudRate,samplerate)
%

if nargin<1 || isempty(COMport)
    COMport = 15;
end

if nargin<2 || isempty(baudRate)
    baudRate = 115200;
end

if nargin<3 || isempty(samplerate)
    samplerate = 1000;
end

system(sprintf('matlab -nojvm -nosplash -r "l = serialportserver(3020,%d,%d,%d,1);listen(l);" &',samplerate,COMport,baudRate));