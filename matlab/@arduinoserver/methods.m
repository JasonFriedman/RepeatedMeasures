% METHODS - Display class methods names (overloaded version)

function rv = methods(c)

if nargout > 0
    rv1 = methods('arduinoserver');
    rv2 = methods('socketserver');
    rv = [rv1(:)' rv2(:)']';
else
    methods('arduinoserver');
    methods('socketserver');
end

