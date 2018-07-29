function out = RandomGraph(X,S)

% Produce a random edge on a graph defined by S
%
% inputs:
%   X: current node
%   S: Connections matrix, S(i,j) lists the number of edges between node i
%   and node j

V = S(:,X); % Node this one is connected with
Idx = find(V);

v = V(Idx)/sum(V);
s = cumsum(v);

r = rand;

ind = find(s > r);

out = Idx(ind(1));

end


