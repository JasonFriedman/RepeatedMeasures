% RUNCHARACTERSERVER - run a character server on port 3033 in another matlab process
function runcharacterserver(filename)

if isnumeric(filename)
    filename = num2str(filename);
end

if ispc
       system(['matlab -nojvm -nosplash -r "c = characterserver(3033,1000,''' filename ''',1);listen(c)" &']);
elseif ismac
           system(['osascript -e "tell application \"Terminal\" to do script \"cd `pwd`;matlab -nojvm -nosplash -r ''c = characterserver(3033,1000,' filename ',1);listen(c)''\""']);

else
        error('Only supported on mac or Windows');
end
