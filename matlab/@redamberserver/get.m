% GET - generic get function (for classes, will look in superclass)
%
% result = get(h,field)

function result = get(h,field)

if nargin==2
    thefields = fields(h);
    isafield = 0;
    superclass = [];
    for k=1:numel(thefields)
        if strcmp(field,thefields{k})
            isafield = 1;
        elseif isa(h.(thefields{k}),thefields{k}) % if this is a class
            superclass = h.(thefields{k});
        end
    end
    if isafield
        if max(size(h))==1
            eval(['result = h.' field ';']);
        else
            for i=1:size(h,1)
                for j=1:size(h,2)
                    eval(['result(i,j) = h(i,j).' field ';']);
                end
            end
        end
    elseif ~isempty(superclass)
        result = get(superclass,field);
    else
        error(['There is no field ' field ' in this object']);
    end
elseif nargin==1
    result = fields(h);
end
