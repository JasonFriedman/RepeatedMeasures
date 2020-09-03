% RUNTRAKSTARSERVER - run a trakStar server on port 3019 in another matlab
% runtrakStarserver(numsensors,samplerate,dllpath)

function runtrakStarserver(numsensors,samplerate,dllpath)

if nargin<1 || isempty(numsensors)
    numsensors = 1;
end

if nargin<2 || isempty(samplerate)
    samplerate = 240;
end

if nargin<3 || isempty(dllpath)
    dllpath = 'D:\equipment\trakStar\MatlabDemo';
end

port = 3019;
todebug = 1;

system(sprintf('matlab -nojvm -nosplash -r "ts = trakStarserver(%d,%d,%d,''%s'',%d);listen(ts);" &',port,samplerate,numsensors,dllpath,todebug));