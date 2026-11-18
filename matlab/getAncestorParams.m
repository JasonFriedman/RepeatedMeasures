% GETANCESTORPARAMS - parameter definitions of the parent, grandparent, ... of a class
%
% ancestors = getAncestorParams(params)
%
% params is the parameter definition of a class (the second output of its constructor).
% ancestors is a cell array with the parameter definitions of its parent class, then of
% the parent of that class, and so on (following params.parentclassname), e.g. for
% forcesensorsclient: {DAQclient params, socketclient params}.
% It is empty if the class has no parent.

function ancestors = getAncestorParams(params)

ancestors = {};
seen = {};
while isfield(params,'parentclassname') && ~isempty(params.parentclassname)
    parent = params.parentclassname;
    if any(strcmp(seen,parent))
        error('The class hierarchy of %s has a loop (%s)',char(params.classname),strjoin([seen {parent}],' -> '));
    end
    seen{end+1} = parent; %#ok<AGROW>
    [~,params] = feval(parent);
    ancestors{end+1} = params; %#ok<AGROW>
end
