% GET - generic get function (for array)
%
% result = get(h,field)

function result = get(h,field)

if nargin==2
    if max(size(h))==1
        result = h.(field);
    else
        for i=1:size(h,1)
            for j=1:size(h,2)
                result(i,j) = h(i,j).(field);
            end
        end
    end
        
elseif nargin==1
    result = fields(h);
end
