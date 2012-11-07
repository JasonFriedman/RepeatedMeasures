function subtree = branch(tree,uid)
% XMLTREE/BRANCH Branch Method
% FORMAT uid = parent(tree,uid)
% 
% tree    - XMLTree object
% uid     - UID of the root element of the subtree
% subtree - XMLTree object (a subtree from tree)
%_______________________________________________________________________
%
% Return a subtree from a tree.
%_______________________________________________________________________
% @(#)branch.m                  Guillaume Flandin              02/04/17

error(nargchk(2,2,nargin));

if uid > length(tree) | ...
   prod(size(uid))~=1 | ...
   ~strcmp(tree.tree{uid}.type,'element')
	error('[XMLTree] Invalid UID.');
end

subtree = xmltree;
subtree = set(subtree,root(subtree),'name',tree.tree{uid}.name);

child = children(tree,uid);

for i=1:length(child)
	l = length(subtree);
	subtree = sub_branch(tree,subtree,child(i),root(subtree));
	subtree.tree{root(subtree)}.contents = [subtree.tree{root(subtree)}.contents l+1];
end

%=======================================================================
function tree = sub_branch(t,tree,uid,p)

	l = length(tree);
	tree.tree{l+1} = t.tree{uid};
	tree.tree{l+1}.uid = l + 1;
	tree.tree{l+1}.parent = p;
	tree.tree{l+1}.contents = [];
	if isfield(t.tree{uid},'contents')
		contents = get(t,uid,'contents');
		m = length(tree);
		for i=1:length(contents)
			tree.tree{l+1}.contents = [tree.tree{l+1}.contents m+1];
			tree = sub_branch(t,tree,contents(i),l+1);
			m = length(tree);
		end
	end
