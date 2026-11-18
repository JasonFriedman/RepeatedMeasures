% RMTESTWORKDIR - make a temporary experiment directory (with stimuli) and cd into it
%
% [workDir,oldDir] = rmtestWorkDir()
%
% The directory contains copies of sampleexperiments/stimuli and
% sampleexperiments/matlab, and empty protocols / results directories, so that tests never
% write into the repository. Use rmtestCleanup(workDir,oldDir) when finished.
function [workDir,oldDir] = rmtestWorkDir()
info = rmtestSetup_info();
oldDir = pwd;
workDir = tempname;
mkdir(workDir);
copyfile([info.root '/sampleexperiments/stimuli'],[workDir '/stimuli']);
copyfile([info.root '/sampleexperiments/matlab'],[workDir '/matlab']);
mkdir([workDir '/protocols']);
mkdir([workDir '/results']);
cd(workDir);
addpath([workDir '/matlab']);

function info = rmtestSetup_info()
testsDir = fileparts(fileparts(mfilename('fullpath')));
info.root = fileparts(testsDir);
