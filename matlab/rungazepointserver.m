% RUNGAZEPOINTSERVER - run a gazepoint server on port 3021 in another matlab process
function rungazepointserver(fixationbox,fixationratio)

if nargin==0
    !matlab -nodesktop -nosplash -r "m = gazepointserver(3021,1000,1);listen(m)" &
else
    fixationboxstring = sprintf('[%.4f %.4f %.4f %.4f]',fixationbox(1),fixationbox(2),fixationbox(3),fixationbox(4));
    runstring = sprintf('matlab -nodesktop -nosplash -r "m = gazepointserver(3021,1000,1,%s,%f);listen(m)" &',...
        fixationboxstring,fixationratio);

    runstring
    system(runstring);
end
