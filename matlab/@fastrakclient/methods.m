% METHODS - Display class methods names (overloaded version)

function rv = methods(mbc)

if nargout > 0
    rv1 = methods('fasttrakclient');
    rv2 = methods('socketclient');
    rv = {rv1{:} rv2{:}}';
else
    methods('fasttrakclient');
    methods('socketclient');
end

