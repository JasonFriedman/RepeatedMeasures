% RUNMOUSESERVER - run a mouse server on port 3003 in another matlab process
function runmouseserver

if ispc
        !matlab -nojvm -nosplash -r "m = mouseserver(3003,1000,1);listen(m)" &

elseif ismac
        ! osascript -e "tell application \"Terminal\" to do script \"cd `pwd`;matlab -nojvm -nosplash -r 'k = mouseserver(3003,1000,1);listen(k)'\""
else
        error('Only supported on mac or Windows');
end
