% RUNTABLETSERVER - run a glove server on port 3011 in another matlab process
function runtabletserver

if ~strcmp(mexext,'mexw32')
    error('The tablet server only runs with 32-bit matlab on Windows');
end

! matlab -nojvm -r "t = tabletserver(3009,200,1);listen(t)" &
