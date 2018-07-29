% -----------------------------------------------
% to_XY - Transrformee Ternaire -> Orthogonal 
% Cette fonction est vectorisee
%   et accepte une suite de points en entree
%   size(abc) = [3, N], size(xy) = [2, N]
%
% F. Andrianasy, Ven13Aug2010, 16h25
% -----------------------------------------------
function xy = to_XY(abc, A, B)
    xy = A* abc + B*ones(size(B,2), size(abc,2));
end
