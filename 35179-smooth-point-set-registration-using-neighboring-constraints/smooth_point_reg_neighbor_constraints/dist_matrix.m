% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Computes the Euclidean distance between two n-dimensional point-sets
% 
% Input:
%   g1,g2: input point sets
% 
% Output:
%   Dist: output distance matrix
% 

function Dist = dist_matrix(g1,g2)

l1 = size(g1,1);
l2 = size(g2,1);

Dist = zeros(l1,l2);
for it_dim = 1:size(g1,2)
    Dist = Dist + ...
        ((g1(:,it_dim)*ones(1,l2) - ones(l1,1)*g2(:,it_dim)').^2);
end
Dist = sqrt(Dist);
