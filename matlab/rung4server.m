function rung4server(nummarkers,configFilePath)
% RUNG4SERVER - run the G4 server with standard settings
% rung4server(nummarkers,configFilePath)
%
% default is one marker
if nargin<1 || isempty(nummarkers)
    nummarkers = 1;
end

if nargin<2 || isempty(configFilePath)
    configFilePath = 'c:\configfile.g4c';
end

system(sprintf('matlab -nojvm -nosplash -r "g = g4server(3025,%d,''%s'',1);listen(g);" &',nummarkers,configFilePath));


