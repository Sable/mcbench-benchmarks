% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Sets arcs according to a mutual K-nearest-neighbour criterion so that 2
% nodes are joined by an edge iff both of them are among the K closest
% neighbours of each other
% 
% Input:
%   g: 2D coordinates of the graph nodes
%   K: number of neighbours
% 
% Output:
%   a1,a2: edges so that i-th edge joins a1(i)-th and a2(i)-th nodes
% 

function [a1,a2] = adjKNN_eff(g,K)

l = length(g);
D = zeros(l);
for it_dim = 1:2
    D = D +(g(:,it_dim)*ones(1,l) - ones(l,1)*g(:,it_dim)').^2;
end
D = sqrt(D);
% 
I1 = (1:l)'*ones(1,l);
[V,I2] = sort(D,2,'ascend');
nv = (I1(:) == I2(:));  % No self-loops
I1(nv) = [];
I2(nv) = [];
I1 = I1(1:K*l);
I2 = I2(1:K*l);
% 
A = false(l);
A(sub2ind(size(A),I1,I2)) = true;
A = (A & A');  % mutual K-nearest-neighbours
[a1,a2] = ind2sub(size(A),find(A(:)));
% 
A = double(A);
nv = (a1(:) < a2(:));
a1(nv) = [];
a2(nv) = [];


