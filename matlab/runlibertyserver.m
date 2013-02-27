function runlibertyserver(nummarkers,COMport,recordOrientation)
% RUNLIBERTYSERVER - run the liberty server with standard settings
% runlibertyservetr(nummarkers,COMport,recordOrientation)
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



system(sprintf('matlab -nojvm -nosplash -r "l = libertyserver(3015,240,%d,%d,1,%d,1);listen(l);" &',nummarkers,recordOrientation,COMport));


