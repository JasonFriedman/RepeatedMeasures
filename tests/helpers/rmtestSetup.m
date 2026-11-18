% RMTESTSETUP - prepare the path for running the RepeatedMeasures tests
%
% info = rmtestSetup(mode)
%
% mode is one of
%   'auto'      (default) simulate the devices; simulate the Psychtoolbox only if it is
%               not installed
%   'simulated' simulate the devices and the Psychtoolbox (even if it is installed). This
%               is fully deterministic and fast (virtual clock) and needs no display
%   'hardware'  nothing is simulated: the real msocket and Psychtoolbox are used (for the
%               tests in tests/hardware, which talk to real device servers)
%
% info is a struct describing what was set up (fields root, mode, octave,
% simulatedPsychtoolbox, simulatedDevices)
function info = rmtestSetup(mode)
if nargin<1 || isempty(mode)
    mode = 'auto';
end
if ~any(strcmp(mode,{'auto','simulated','hardware'}))
    error('rmtestSetup: mode must be ''auto'', ''simulated'' or ''hardware''');
end
testsDir = fileparts(fileparts(mfilename('fullpath')));
root = fileparts(testsDir);

info.root = root;
info.testsDir = testsDir;
info.mode = mode;
info.octave = exist('OCTAVE_VERSION','builtin') ~= 0;

% Remove our stubs from the path first, so that we can see what is really installed
stubDirs = {[testsDir '/stubs/psychtoolbox'],[testsDir '/stubs/msocket'],[testsDir '/stubs/misc']};
warnState = warning('off','all');
for k=1:numel(stubDirs)
    rmpath(stubDirs{k});
end
warning(warnState);

addpath([root '/matlab']);
addpath([root '/matlab/xmltree']);
addpath([root '/matlab/msocket']);
addpath([testsDir '/helpers']);
addpath([testsDir '/suites']);
if info.octave
    addpath([testsDir '/compat/octave']);
    warning('off','Octave:language-extension');
    warning('off','Octave:legacy-function');
    warning('off','Octave:possible-matlab-short-circuit');
    warning('off','Octave:shadowed-function');
    warning('off','Octave:function-name-clash');
    more off;
end

havePsychtoolbox = exist('Screen','file')==3 || exist('Screen','file')==2;
info.simulatedPsychtoolbox = strcmp(mode,'simulated') || (strcmp(mode,'auto') && ~havePsychtoolbox);
info.simulatedDevices = ~strcmp(mode,'hardware');

if info.simulatedPsychtoolbox
    addpath([testsDir '/stubs/psychtoolbox']);
    addpath([testsDir '/stubs/misc']);
end
if info.simulatedDevices
    addpath([testsDir '/stubs/msocket']);
    if ~info.simulatedPsychtoolbox
        warning('rmtest:mixed',['The devices are simulated but the real Psychtoolbox is used: tests ' ...
            'that run a whole experiment are skipped (they need the simulated clock). Use ' ...
            'rmtestSetup(''simulated'') to run them.']);
    end
end
rmtestWorld('reset');
