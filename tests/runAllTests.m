% RUNALLTESTS - run the RepeatedMeasures test suite
%
% results = runAllTests            run everything that can run on this computer
% results = runAllTests(mode)      mode = 'auto' (default), 'simulated' or 'hardware'
%                                  (see tests/helpers/rmtestSetup.m)
% results = runAllTests(mode,pattern)  only run test files whose name matches the regular
%                                  expression, e.g. runAllTests('auto','readParameters')
%
% No devices and no Psychtoolbox are needed: in 'auto' and 'simulated' mode the device
% servers run in-process and (if the Psychtoolbox is missing) the Psychtoolbox functions
% are replaced by stubs with a virtual clock. The tests work in MATLAB and in GNU Octave.
%
% Each file tests/suites/test_*.m is a function that returns a struct array of test
% cases (name + function handle). results is a struct array with the fields
% suite, name, status ('passed', 'failed' or 'skipped'), message and duration.
%
% From the command line (e.g. for continuous integration):
%   octave --no-gui --eval "cd tests; r = runAllTests; exit(any(strcmp({r.status},'failed')))"
%   matlab -batch "cd tests; r = runAllTests; exit(any(strcmp({r.status},'failed')))"
function results = runAllTests(mode,pattern)
if nargin<1 || isempty(mode)
    mode = 'auto';
end
if nargin<2
    pattern = '';
end
here = fileparts(mfilename('fullpath'));
addpath([here '/helpers']);
info = rmtestSetup(mode);
startDir = pwd;

if strcmp(mode,'hardware')
    suiteDir = [here '/hardware'];
    addpath(suiteDir);
else
    suiteDir = [here '/suites'];
end
files = dir([suiteDir '/test_*.m']);
results = struct('suite',{},'name',{},'status',{},'message',{},'duration',{});

fprintf('RepeatedMeasures tests (%s mode, %s, Psychtoolbox %s, devices %s)\n',mode,...
    pick(info.octave,'Octave','MATLAB'),pick(info.simulatedPsychtoolbox,'simulated','real'),...
    pick(info.simulatedDevices,'simulated','real'));

for k=1:numel(files)
    suite = files(k).name(1:end-2);
    if ~isempty(pattern) && isempty(regexp(suite,pattern,'once'))
        continue;
    end
    fprintf('\n%s\n',suite);
    try
        cases = feval(suite);
    catch err
        results(end+1) = struct('suite',suite,'name','(loading the suite)','status','failed',...
            'message',err.message,'duration',0); %#ok<AGROW>
        fprintf('  FAILED to load: %s\n',err.message);
        continue;
    end
    for c=1:numel(cases)
        rmtestWorld('reset');
        tstart = tic;
        status = 'passed';
        message = '';
        try
            cases(c).fcn(info);
        catch err
            if strcmp(err.identifier,'rmtest:skip')
                status = 'skipped';
                message = err.message;
            else
                status = 'failed';
                message = err.message;
                if ~isempty(err.stack)
                    message = sprintf('%s (in %s, line %d)',message,err.stack(1).name,err.stack(1).line);
                end
            end
        end
        % A failing test must not leave us in a temporary directory or with open files
        fclose('all');
        cd(startDir);
        results(end+1) = struct('suite',suite,'name',cases(c).name,'status',status,...
            'message',message,'duration',toc(tstart)); %#ok<AGROW>
        switch status
            case 'passed'
                fprintf('  ok       %s\n',cases(c).name);
            case 'skipped'
                fprintf('  skipped  %s: %s\n',cases(c).name,message);
            otherwise
                fprintf('  FAILED   %s\n           %s\n',cases(c).name,message);
        end
    end
end

statuses = {results.status};
fprintf('\n%d passed, %d failed, %d skipped (%.1f s)\n',sum(strcmp(statuses,'passed')),...
    sum(strcmp(statuses,'failed')),sum(strcmp(statuses,'skipped')),sum([results.duration]));

function s = pick(condition,a,b)
if condition
    s = a;
else
    s = b;
end
