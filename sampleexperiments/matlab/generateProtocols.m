% GENERATEPROTOCOLS - generate all the sample protocols described in the paper
%
% generateProtocols

if ~exist('protocols','dir')
    mkdir('protocols');
end

% Test loading all files
d = dir('matlab/generate*.m');

for k=1:numel(d)
    fn = d(k).name;
    if ~strcmp(fn,'generateProtocols.m')
        fprintf('Testing %s\n',fn);
        run(strrep(fn,'.m',''));    
    end
end
