% RMTESTCLEANUP - leave and delete a directory made by rmtestWorkDir
function rmtestCleanup(workDir,oldDir)
fclose('all');
cd(oldDir);
warnState = warning('off','all');
rmpath([workDir '/matlab']);
warning(warnState);
try %#ok<TRYNC>
    if exist('OCTAVE_VERSION','builtin')
        confirm_recursive_rmdir(false,'local');
    end
    rmdir(workDir,'s');
end
