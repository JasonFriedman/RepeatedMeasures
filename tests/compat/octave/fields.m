% FIELDS - Octave compatibility shim (MATLAB's fields is a synonym of fieldnames)
function f = fields(s)
f = fieldnames(s);
