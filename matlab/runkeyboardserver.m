% RUNKEYBOARDSERVER - run a keyboard server on port 3002 in another matlab process
function runkeyboardserver

if ispc
	! matlab -nojvm -nosplash -r "k = keyboardserver(3002,1000,1);listen(k)" &
elseif ismac
	! osascript -e "tell application \"Terminal\" to do script \"cd `pwd`;matlab -nojvm -nosplash -r 'k = keyboardserver(3002,1000,1);listen(k)'\""
else
	error('Only supported on mac or Windows');
end

