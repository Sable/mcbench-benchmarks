

function [m,n,p,D,tail,head,W] = Initialize(G)
%
% Transforms the sparse matrix G into the list-of-arcs form
% and intializes the shortest path parent-pointer and distance
% arrays, p and D.
% Derek O'Connor, 21 Jan 2012

[tail,head,W] = find(G); % Get arc list {u,v,duv, 1:m} from G.
[~,n] = size(G); 
m = nnz(G);
p(1:n,1) = 0;            % Shortest path tree of parent pointers
D(1:n,1) = Inf;          % Sh. path distances from node i=1:n to 
                         % the root of the sp tree
                
% NOTE: After a shortest path function calls this function
%       it will need to set D(r) = 0, for a given r, the root
%       of the shortest path tree it is about to construct.

    
    


