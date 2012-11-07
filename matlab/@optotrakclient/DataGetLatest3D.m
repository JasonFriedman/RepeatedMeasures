% DATAGETLATEST3D - get the latest sample
%
% data = DataGetLatest3D(oc)

function data = DataGetLatest3D(oc)

codes = messagecodes;

m.command = codes.OPTO_DataGetLatest3D;
m.parameters = oc.numbermarkers;

sendmessage(oc,m,'DataGetLatest3D');
% receieve the response
data = receivemessage(oc);

if get(oc,'debug')
    if ~isstruct(data)
        error('Did not receive data in return');
    end
    for i=1:oc.numbermarkers
        fprintf('Marker %d is (%.2f,%.2f,%.2f)\n',...
            i,data.Markers{i}(1),data.Markers{i}(2),data.Markers{i}(3));
    end
end
