function [v,newParamsParent] = readParameters(params,newParams,v)

if (numel(params.name) ~= numel(params.type) || ...
        numel(params.name) ~= numel(params.description) || ...
        numel(params.name) ~= numel(params.required) || ...
        numel(params.name) ~= numel(params.default))
    error(['The number of elements must be the same in all fields of params in ' params.classname]);
end

if ~isfield(params,'classdescription')
    error('All classes must have a field params.classdescription with a description of what the class does.');
end

if strcmp(params.classname,'mouseInBoxstart')
    keyboard;
end

thefields = fields(params);
for k=1:numel(thefields)
    if ~any(strcmp({'name','type','description','required','default','classname','classdescription','parentclassname'},thefields{k}))
        error(['Unknown field ' thefields{k} ' in ' params.classname]);
    end
end

% get the parameters for the parent class
if isfield(params,'parentclassname')
    eval(['[v_tmp,paramsParent] = ' params.parentclassname '();']);
    if numel(paramsParent.name)==0
        newParamsParent = struct();
    end
    for m=1:numel(paramsParent.name)
        if isfield(newParams,paramsParent.name{m})
            newParamsParent.(paramsParent.name{m}) = newParams.(paramsParent.name{m});
            newParams = rmfield(newParams,paramsParent.name{m});
        end
    end
    % Also do for grandparent (if exists)
    if isfield(paramsParent,'parentclassname')
        eval(['[v_tmp,paramsGrandParent] = ' paramsParent.parentclassname '();']);
        if numel(paramsGrandParent.name)>0
            for m=1:numel(paramsGrandParent.name)
                if isfield(newParams,paramsGrandParent.name{m})
                    newParamsParent.(paramsGrandParent.name{m}) = newParams.(paramsGrandParent.name{m});
                    newParams = rmfield(newParams,paramsGrandParent.name{m});
                end
            end
        end
    end
else
    newParamsParent = struct;
end

if isempty(params.name)
    v = struct();
    return;
end


if iscell(newParams)
    for m=1:numel(newParams)
        % initialize the values
        for n=1:numel(params.name)
            if ~exist('v','var') || isempty(v) || numel(v)<m || ~isfield(v{m},params.name{n})
                v{m}.(params.name{n}) = params.default{n};
            end
        end
        newParamsFields = fields(newParams{m});
        for k=1:numel(newParamsFields)
            v{m}.(newParamsFields{k}) = parseField(params,newParamsFields{k},newParams{m}.(newParamsFields{k}));
        end
        for k=1:numel(params.name)
            if params.required(k) && ~any(ismember(newParamsFields,params.name{k})) && ~strcmp(params.type{k},'ignore')
                error(['Must specify ' params.name{k} ' for ' params.classname]);
            end
        end
    end
else
    % initialize the values
    for m=1:numel(params.name)
        if ~exist('v','var') || isempty(v) || ~isfield(v,params.name{m})
            v.(params.name{m}) = params.default{m};
        end
    end
    if isempty(newParams)
        newParamsFields = [];
    else
        if ~isstruct(newParams)
            error([params.classname ' is expected to be a struct']);
        end
        newParamsFields = fields(newParams);
    end
    for k=1:numel(newParamsFields)
        v.(newParamsFields{k}) = parseField(params,newParamsFields{k},newParams.(newParamsFields{k}));
    end
    for k=1:numel(params.name)
        if any(params.required(k)==[1 3]) && ~any(ismember(newParamsFields,params.name{k})) && ~strcmp(params.type{k},'ignore')
            error(['Must specify ' params.name{k} ' for ' params.classname]);
        end
    end
end

end

%%%%%%%%%%%%%%%%%%%%
function newparam = parseField(params,thisparamname,thisparam)

setVal = 0;
for m=1:numel(params.name)
    if strcmp(thisparamname,params.name{m})
        if isstruct(params.type{m})
            % If it is a struct, this is the definition for more parameters
            %params.type{m}.classname = [params.classname ':' thisparamname];
            newparam = readParameters(params.type{m},thisparam);
        elseif iscell(params.type{m})
            % If it is a cell array, the child can be any of the classes
            % So pick the appropriate one
            cellsetVal = 0;
            for n=1:numel(params.type{m})
                if strcmp(params.type{m}{n}.classname,fields(thisparam))
                    %params.type{m}{n}.classname = [params.classname ':' thisparamname ':' params.type{m}{n}.classname];
                    newparam.(params.type{m}{n}.classname) = readParameters(params.type{m}{n},thisparam.(params.type{m}{n}.classname));
                    cellsetVal = 1;
                end
            end
            if cellsetVal==0
                error(['The parameter ' thisparamname ' did not match any of the options in ' params.classname]);
            end
        elseif strcmp(params.type{m},'matrix')
            newparam = str2num(thisparam); %#ok
            % matrix_1_3 requires it to be 1 1x3 matrix
        elseif strncmp(params.type{m},'matrix',6)
            newparam = str2num(thisparam); %#ok
            sizeparams = regexp(params.type{m},'matrix_([n0-9]*)_([n0-9]*)','tokens');
            if strcmp(sizeparams{1}{1},'n') % ignore this param if n
            else
                matrixheight = str2double(sizeparams{1}{1});
                if size(newparam,1) ~= matrixheight
                    error(['Height of matrix ' thisparamname ' in ' params.classname ' is the wrong size (should be ' num2str(matrixheight) ')']);
                end
            end
            if strcmp(sizeparams{1}{2},'n') % ignore this param if n
            else
                matrixwidth = str2double(sizeparams{1}{2});
                if size(newparam,2) ~= matrixwidth
                    error(['Width of matrix ' thisparamname ' in ' params.classname ' is the wrong size (should be ' num2str(matrixwidth) ')']);
                end
            end
        elseif strcmp(params.type{m},'number')
            newparam = str2double(thisparam);
        elseif strcmp(params.type{m},'boolean')
            newparam = str2double(thisparam);
            if newparam~=0 && newparam ~=1
                error(['The parameter ' thisparamname ' in ' params.classname ' needs to be boolean (0 or 1) ']);
            end
        elseif strcmp(params.type{m},'cellarray')
            newparam = thisparam;
            if ~iscell(newparam)
                tmp = newparam;
                clear newparam;
                newparam{1} = tmp;
            end
        elseif strcmp(params.type{m},'string')
            newparam = thisparam;
        elseif strcmp(params.type{m},'loadArray')
            newparam = load(['stimuli/' thisparam]);
        elseif strcmp(params.type{m},'ignore') % This will be dealt with by the class
            newparam = [];
        else
            error(['Unknown type of field ' params.type{m} ' in ' params.classname]);
        end
        setVal = 1;
    end
end
if setVal==0
    error(['Unknown field ' thisparamname ' in ' params.classname]);
end
end

