% SET - generic set function

function s = set(s,varargin)
if mod(length(varargin),2) ~= 0
    error('There must be pairs of arguments, with the field name and its value');
end
for k=1:length(varargin)/2
    s.(varargin{k*2-1}) = varargin{k*2};
end
