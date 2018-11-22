% RUNBLUETERASERVER - run a bluetera server on port 3027 in another matlab
% runblueteraserver(numsensors)

function runblueteraserver(numsensors)

if nargin<1 || isempty(numsensors)
    numsensors = 1;
end

port = 3027;
todebug = 1;

system(sprintf('matlab -nojvm -nosplash -r "bt = blueteraserver(%d,%d,%d);listen(bt);" &',port,numsensors,todebug));