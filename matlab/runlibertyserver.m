function runlibertyserver(nummarkers)
% RUNLIBERTYSERVER - run the liberty server with standard settings
% runlibertyservetr(nummarkers)
%
% default is one marker
if nargin<1 || isempty(nummarkers)
    nummarkers = 1;
end

system(['matlab -nojvm -nosplash -r "l = libertyserver(3015,240,' num2str(nummarkers) ',0,1,1,1);listen(l);" &']);


