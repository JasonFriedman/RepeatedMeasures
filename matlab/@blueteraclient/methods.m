% METHODS - Display class methods names (overloaded version)

function rv = methods(c)

if nargout > 0
    rv1 = methods('blueteraclient');
    rv2 = methods('socketclient');
    rv = {rv1{:} rv2{:}}';
else
    methods('blueteraclient');
    methods('socketclient');
end

