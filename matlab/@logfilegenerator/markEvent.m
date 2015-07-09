% MARKEVENT - mark an event
%
% markEvent(e,eventNumber)
%
% eventNumber is the number that will end up in the last column of the data file

function markEvent(e,eventNumber)

devicelist = fields(e.devices);
for k=1:length(devicelist)
    markEvent(e.devices.(devicelist{k}),eventNumber);
    writetolog(e,sprintf('Marked event in %s with number %d',devicelist{k},eventNumber));
end

if isempty(devicelist)
    fprintf('No devices to mark event on\n');
    writetolog(e,'No devices to mark event on');
end