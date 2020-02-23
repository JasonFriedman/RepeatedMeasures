% RUNGOPROSERVER - run a gopro server on port 3030 in another matlab
% rungoroserver

function rungoproserver

port = 3030;
todebug = 1;

system(sprintf('matlab -nojvm -nosplash -r "gs = goproserver(%d,%d);listen(gs);" &',port,todebug));