function ti = treeinfo(X, y, treeopts, tstopts)
%TREEINFO Collects decision tree information based on tree walking.
%
%   ti = treeinfo(X, y, treeopts, tstopts)
% 
%   It creates CART according to data set [X, y] and 
%   optional parameters in treeopts, performs 
%   tree pruning (if required) according to optional 
%   parameters in tstopts, and implements tree walking 
%   to collect all necessary information for genfis4.
%   treeopts and tstopts should be either empty matrix or
%   cell array containing one or more optional 
%   parameter name/value pairs.
% 
%   The result is a structure ti containing the following fields:
%   - structure array "node" with fields "variable" (integer-valued scalar), 
%       "cutpoint" (float scalar), and "sample" (index-valued vector);
%   - structure array "leaf" with field "sample" (index-valued vector);
%   - structure array "branch" with fields "nodes" (integer-valued vector),
%       and "ineqs" (vector of "1" or "-1" values).
% 
%   It requires Statistics Toolbox realizing CART algorithm.
% 
%   Example:
%   load fisheriris;
%   treeopts = {'minparent', 5, 'prune', 'off'};
%   tstopts = {'crossvalidation', meas, species};
%   ti = treeinfo(meas, species, treeopts, tstopts);
 
%   Per Konstantin A. Sidelnikov, 2009.

% Check inputs
error(nargchk(2, 4, nargin));

if (nargin < 4) || isempty(tstopts)
    tstopts = {};
end
if (nargin < 3) || isempty(treeopts)
    treeopts = {};
end    

% Create a decision tree using CART algorithm
t = classregtree(X, y, treeopts{:});
% If necessary, perfom optimal tree pruning
if ~isempty(tstopts)
    [~, ~, ~, bestlevel] = t.test(tstopts{:});
    t = t.prune('level', bestlevel);   
end
% Get indices of nodes and leaves (terminal nodes)
indn = find(t.isbranch());
indl = find(~t.isbranch());
% Get overall numbers of nodes and leaves
numn = length(indn);
numl = length(indl);
% Allocate memory for structure array,
% which stores information about each branch nodes:
% cut variable number, cut point, and observations from 
% the original data that satisfy the conditions for the node
node(numn).variable = [];
node(numn).cutpoint = [];
node(numn).sample = [];
% Allocate memory for structure array,
% which stores information about each leaves:
% observations from the original data that 
% satisfy the conditions for the leaf
leaf(numl).sample = [];
% Allocate memory for structure array,
% which stores information about each branches:
% group of nodes that form a path to the leaf, and
% types of inequalities that are satisfied to reach the leaf
branch(numl).nodes = [];
branch(numl).ineqs = [];
% Implement tree walking
treewalk(1, [], [], 1 : length(y));
% Collect tree information
ti = struct('node', node, 'leaf', leaf, 'branch', branch);

    function treewalk(n, nodes, ineqs, sample)
        %   This nested function implements tree walking
        %   based on recursive algorithm in reference and 
        %   collects tree information using data sharing.
                
        %   Reference: Cormen T.H., Leiserson C.E., Rivest R.L.,
        %   Introduction to Algorithms (1st ed.), 
        %   MIT Press and McGraw-Hill, 1990.
        
        % Get numbers of the child nodes
        kids = t.children(n);        
        if all(kids) % branch node
            % Get cut variable and cut point
            var = t.var(n);
            cut = t.cutpoint(n);
            % Save cut variable, cut point, and observations
            k = find(n == indn, 1, 'first');
            node(k).variable = var;
            node(k).cutpoint = cut;
            node(k).sample = sample;
            % Form new subsample and continue walking to the left child
            s = sample(X(sample, var) < cut);            
            treewalk(kids(1), [nodes, k], [ineqs, -1], s);
            % Form new subsample and continue walking to the right child
            s = sample(X(sample, var) >= cut);
            treewalk(kids(2), [nodes, k], [ineqs, 1], s);
        else % leaf
            % Save leaf and branch information
            k = find(n == indl, 1, 'first');            
            leaf(k).sample = sample;            
            branch(k).nodes = nodes;
            branch(k).ineqs = ineqs;
        end
    end
end