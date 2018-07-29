% function [norm_mat] = get_normalization_matrices(x)
% computes the norm_mat such that if transformed by norm_mat
% x is approximately centered around the origin and has
% an average distance of \sqrt{2} to origin.
% inputs:		x			3xN homogeneous coordinates of x
% ourputs:		norm_mat 	3x3	see above
function [norm_mat] = get_normalization_matrix(x)
if size(x,1) ~= 3; error('point should have dimension 3xN'), end
if sum(isnan(x(:))) || sum(isinf(x(:))), error('points can not be on infinity'), end
if sum(x(3,:) < 1e-10), error('this method does not support points at infinity'), end % although points might be improperly scaled!
centroid = mean(x,2);
dists = sqrt(sum((x - repmat(centroid,1,size(x,2))).^2,1));
mean_dist = mean(dists);
norm_mat = [sqrt(2)/mean_dist 0 -sqrt(2)/mean_dist*centroid(1);...
            0 sqrt(2)/mean_dist -sqrt(2)/mean_dist*centroid(2);...
            0 0 1];
end





