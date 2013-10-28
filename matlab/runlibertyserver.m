function runlibertyserver(nummarkers,COMport,recordOrientation,samplerate)
% RUNLIBERTYSERVER - run the liberty server with standard settings
% runlibertyserver(nummarkers,COMport,recordOrientation,samplerate)
%
% COMport of -1 indicates to use USB
%
% default is one marker, COMport = 1, recordOrientation = 0
if nargin<1 || isempty(nummarkers)
    nummarkers = 1;
end

if nargin<2 || isempty(COMport)
    COMport = 1;
end

if nargin<3 || isempty(recordOrientation)
    recordOrientation = 1;
end

if nargin<4 || isempty(samplerate)
    samplerate = 240;
end

system(sprintf('matlab -nojvm -nosplash -r "l = libertyserver(3015,%d,%d,%d,1,%d,1);listen(l);" &',samplerate,nummarkers,recordOrientation,COMport));


