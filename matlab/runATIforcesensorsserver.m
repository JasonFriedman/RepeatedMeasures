% RUNATIFORCESENSORSSERVER - run an ATI force sensors server on port 3011 in another matlab process
%
% runATIforcesensorsserver(numsensors,samplerate)
%

function runATIforcesensorsserver(numsensors,samplerate,IPaddress)

if nargin<1
    numsensors = 1;
end

% port,samplerate,channels,IPaddress

runstring = sprintf('matlab -nodesktop -r "d = ATIforcesensorsserver(3011,%d,%d,''%s'');listen(d)" &',...
        samplerate,numsensors,IPaddress);

runstring
system(runstring);

