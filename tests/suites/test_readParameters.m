% TEST_READPARAMETERS - tests of readParameters (parsing and checking protocol parameters)
function cases = test_readParameters
cases = [];
cases = rmtestCase(cases,'defaults are used when nothing is specified',@defaults);
cases = rmtestCase(cases,'numbers, booleans, strings and matrices are converted',@conversion);
cases = rmtestCase(cases,'matrix sizes are checked',@matrixSizes);
cases = rmtestCase(cases,'missing required parameters are reported',@required);
cases = rmtestCase(cases,'unknown parameters are reported',@unknown);
cases = rmtestCase(cases,'booleans must be 0 or 1',@booleans);
cases = rmtestCase(cases,'nested structs and "one of" types are parsed',@nested);
cases = rmtestCase(cases,'lists (cell arrays of structs) are parsed',@lists);
cases = rmtestCase(cases,'parameters of the parent class are split off',@parents);
cases = rmtestCase(cases,'malformed parameter definitions are rejected',@malformed);

function p = baseParams
p.name = {'n','b','s','m','m13','mn2','c'};
p.type = {'number','boolean','string','matrix','matrix_1_3','matrix_n_2','cellarray'};
p.description = {'a number','a boolean','a string','a matrix','1x3','nx2','cell'};
p.required = [0 0 0 0 0 0 0];
p.default = {5,0,'hello',[],[1 2 3],[],[]};
p.classdescription = 'test class';
p.classname = 'testclass';

function defaults(info) %#ok<*INUSD,*DEFNU>
v = readParameters(baseParams,[]);
rmtestAssert('equal',v.n,5);
rmtestAssert('equal',v.b,0);
rmtestAssert('equal',v.s,'hello');
rmtestAssert('equal',v.m13,[1 2 3]);
rmtestAssert(isempty(v.m) && isempty(v.c),'empty defaults should stay empty');

function conversion(info)
in.n = '3.5'; in.b = '1'; in.s = 'text'; in.m = '[1 2;3 4]'; in.m13 = '[7 8 9]';
in.mn2 = '[1 2;3 4;5 6]'; in.c = 'single';
v = readParameters(baseParams,in);
rmtestAssert('equal',v.n,3.5);
rmtestAssert('equal',v.b,1);
rmtestAssert('equal',v.s,'text');
rmtestAssert('equal',v.m,[1 2;3 4]);
rmtestAssert('equal',v.m13,[7 8 9]);
rmtestAssert('equal',v.mn2,[1 2;3 4;5 6]);
rmtestAssert('equal',v.c,{'single'},'a single string should become a 1x1 cell array');
in.c = {'a','b'};
v = readParameters(baseParams,in);
rmtestAssert('equal',v.c,{'a','b'});
in.n = 'Inf';
v = readParameters(baseParams,in);
rmtestAssert(isinf(v.n),'Inf should be read as infinity');

function matrixSizes(info)
in.m13 = '[1 2]';
rmtestAssert('error',@() readParameters(baseParams,in),'Width of matrix m13');
in = struct('m13','[1 2 3;4 5 6]');
rmtestAssert('error',@() readParameters(baseParams,in),'Height of matrix m13');
in = struct('mn2','[1 2 3]');
rmtestAssert('error',@() readParameters(baseParams,in),'Width of matrix mn2');

function required(info)
p = baseParams;
p.required(1) = 1;
rmtestAssert('error',@() readParameters(p,struct('s','x')),'Must specify n for testclass');
v = readParameters(p,struct('n','1'));
rmtestAssert('equal',v.n,1);

function unknown(info)
rmtestAssert('error',@() readParameters(baseParams,struct('doesNotExist','1')),'Unknown field doesNotExist');

function booleans(info)
rmtestAssert('error',@() readParameters(baseParams,struct('b','2')),'needs to be boolean');

function nested(info)
inner.name = {'x'}; inner.type = {'number'}; inner.description = {'x'}; inner.required = 1;
inner.default = {0}; inner.classdescription = 'inner'; inner.classname = 'inner';
other = inner; other.classname = 'other'; other.name = {'y'};
p.name = {'child','choice'};
p.type = {inner,{inner,other}};
p.description = {'a struct','one of'};
p.required = [0 0];
p.default = {[],[]};
p.classdescription = 'outer'; p.classname = 'outer';
v = readParameters(p,struct('child',struct('x','4')));
rmtestAssert('equal',v.child.x,4);
v = readParameters(p,struct('choice',struct('other',struct('y','9'))));
rmtestAssert('equal',v.choice.other.y,9);
rmtestAssert('error',@() readParameters(p,struct('choice',struct('nothing',struct('y','9')))),'did not match any of the options');
rmtestAssert('error',@() readParameters(p,struct('child',struct('wrong','4'))),'Unknown field wrong');

function lists(info)
inner.name = {'x','y'}; inner.type = {'number','number'}; inner.description = {'x','y'};
inner.required = [1 2]; inner.default = {0,7}; inner.classdescription = 'inner'; inner.classname = 'inner';
p.name = {'items'}; p.type = {inner}; p.description = {'list'}; p.required = 0; p.default = {[]};
p.classdescription = 'outer'; p.classname = 'outer';
in.items = {struct('x','1'),struct('x','2','y','3')};
v = readParameters(p,in);
rmtestAssert(iscell(v.items) && numel(v.items)==2,'a list should be returned as a cell array');
rmtestAssert('equal',[v.items{1}.x v.items{1}.y v.items{2}.x v.items{2}.y],[1 7 2 3]);
% a parameter that is "zero or more" (required=2) may be left out of a list item
in.items = {struct('y','1'),struct('x','2')};
rmtestAssert('error',@() readParameters(p,in),'Must specify x for inner');

function parents(info)
% keyboardstart has the parent class start, which has no parameters of its own
[k,params] = keyboardstart();
rmtestAssert(isempty(k) && strcmp(params.parentclassname,'start'),'keyboardstart should declare its parent');
% the mouse client has the parent socketclient: server and port belong to the parent
[m,params] = mouseclient([]);
[v,parent] = readParameters(params,struct('maxx','100','maxy','50','server','localhost','port','3003'));
rmtestAssert('equal',[v.maxx v.maxy],[100 50]);
rmtestAssert(isempty(m) && isfield(parent,'server') && isfield(parent,'port') && ~isfield(v,'server'),...
    'server and port should be passed on to the parent class');

function malformed(info)
p = baseParams; p.default = p.default(1:end-1);
rmtestAssert('error',@() readParameters(p,[]),'number of elements must be the same');
p = baseParams; p.required = num2cell(p.required);
rmtestAssert('error',@() readParameters(p,[]),'should be a vector');
p = baseParams; p = rmfield(p,'classdescription');
rmtestAssert('error',@() readParameters(p,[]),'classdescription');
p = baseParams; p.extra = 1;
rmtestAssert('error',@() readParameters(p,[]),'Unknown field extra');
p = baseParams; p.type{1} = 'nonsense';
rmtestAssert('error',@() readParameters(p,struct('n','1')),'Unknown type of field');
