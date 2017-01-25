% RUNREDAMBERSERVER - run a red amber server on port 3026 in another matlab
% runredamberserver(numsensors)

function runredamberserver(numsensors)

if nargin<1 || isempty(numsensors)
    numsensors = 1;
end

port = 3026;
todebug = 1;

system(sprintf('matlab -nojvm -nosplash -r "ts = redamberserver(%d,%d,%d);listen(ts);" &',port,numsensors,todebug));