% METHODS - Display class methods names (overloaded version)

function rv = methods(a)

if nargout > 0
    rv1 = methods('ATIforcesensorsclient');
    rv2 = methods('socketclient');
    rv = {rv1{:} rv2{:}}';
else
    methods('ATIforcesensorsclient');
    methods('socketclient');
end

