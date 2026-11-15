% RMTESTASSERT - assertion helpers for the tests
%
% rmtestAssert(condition,message,...)             - error if the condition is false
% rmtestAssert('equal',a,b,message)               - error if ~isequal(a,b)
% rmtestAssert('near',a,b,tolerance,message)      - error if any(abs(a-b)>tolerance)
% rmtestAssert('error',functionHandle,pattern)    - error unless the function throws an
%                                                   error whose message matches the regexp
function rmtestAssert(varargin)
if ischar(varargin{1})
    switch varargin{1}
        case 'equal'
            if ~isequal(varargin{2},varargin{3})
                error('rmtest:assert','%s (values are not equal: %s vs %s)',msg(varargin,4),show(varargin{2}),show(varargin{3}));
            end
        case 'near'
            a = varargin{2}; b = varargin{3};
            if ~isequal(size(a),size(b)) || any(abs(a(:)-b(:)) > varargin{4})
                error('rmtest:assert','%s (values differ by more than %g: %s vs %s)',msg(varargin,5),varargin{4},show(a),show(b));
            end
        case 'error'
            threw = 0;
            try
                varargin{2}();
            catch err
                threw = 1;
                if numel(varargin)>=3 && isempty(regexp(err.message,varargin{3},'once'))
                    error('rmtest:assert','Expected an error matching "%s" but got "%s"',varargin{3},err.message);
                end
            end
            if ~threw
                if numel(varargin)>=3
                    error('rmtest:assert','Expected an error matching "%s" but no error was thrown',varargin{3});
                else
                    error('rmtest:assert','Expected an error but no error was thrown');
                end
            end
        otherwise
            error('rmtestAssert: unknown assertion type %s',varargin{1});
    end
else
    if ~all(varargin{1}(:))
        if numel(varargin)>1
            error('rmtest:assert',varargin{2:end});
        else
            error('rmtest:assert','Assertion failed');
        end
    end
end

function m = msg(args,n)
if numel(args)>=n
    m = args{n};
else
    m = 'Assertion failed';
end

function s = show(x)
if ischar(x)
    s = ['''' x ''''];
elseif isnumeric(x) || islogical(x)
    s = mat2str(double(x),6);
    if numel(s)>80
        s = [s(1:77) '...'];
    end
else
    s = ['<' class(x) '>'];
end
