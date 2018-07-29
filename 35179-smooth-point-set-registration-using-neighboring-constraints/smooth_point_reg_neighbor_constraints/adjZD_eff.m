% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Sets arcs among the Eave*n/2 closest pairs of points, where 'n' is the
% number of nodes and 'Eave' is the average number of arcs that we want at
% each node
% 
% Input:
%   g: coordinates of the graph nodes
%   Eave: average number of arcs that we want at each node
% 
% Output:
%   a1,a2: edges so that i-th edge joins a1(i)-th and a2(i)-th nodes
% 

function [a1,a2] = adjZD_eff(g,Eave)

l = length(g);
D = zeros(l);
for it_dim = 1:2
    D = D +(g(:,it_dim)*ones(1,l) - ones(l,1)*g(:,it_dim)').^2;
end
D = sqrt(D);
[v,I] = sort(D(:),'ascend');
[N1,N2] = ind2sub(size(D),I);
indx = find(N1 > N2);
% 
[a1,a2] = ind2sub([l,l],I(indx(1:floor(Eave*l/2))));

