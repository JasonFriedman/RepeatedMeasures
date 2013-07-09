% GET - generic get function (for array)
%
% result = get(h,field)

function result = get(h,field)

allfields = fields(h);

if nargin==2
    if any(ismember(allfields,field))
        result = h.(field);
    else
        result = get(h.DAQclient,field);
    end
elseif nargin==1
    result = allfields;
end
