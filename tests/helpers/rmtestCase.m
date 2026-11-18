% RMTESTCASE - add a test case to the list returned by a suite
%
% cases = rmtestCase(cases,name,fcn)   fcn is called as fcn(info), info from rmtestSetup
function cases = rmtestCase(cases,name,fcn)
if isempty(cases)
    cases = struct('name',{},'fcn',{});
end
cases(end+1) = struct('name',name,'fcn',fcn);
