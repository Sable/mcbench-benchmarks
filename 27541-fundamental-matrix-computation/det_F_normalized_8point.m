% function F = det_F_normalized_8point(x1,x2)
% calculated the Fundamental matrix between two views from the normalized 8 point algorithm
% implements algorithm 11.1 of Hartley and Zisserman, Multiple View Geometry in Computer Vision
% inputs: 
%               x1      3xN     homogeneous coordinates of matched points in view 1
%               x2      3xN     homogeneous coordinates of matched points in view 2
% outputs:
%               F       3x3     Fundamental matrix

function F = det_F_normalized_8point(x1,x2)
norm_mat1 = get_normalization_matrix(x1);
norm_mat2 = get_normalization_matrix(x2);
x1n = norm_mat1 * x1;
x2n = norm_mat2 * x2;
W = [ repmat(x2n(1,:)',1,3) .* x1n', repmat(x2n(2,:)',1,3) .* x1n', x1n(1:3,:)'];
[U,S,V] = svd(W);
F_norm = reshape(V(:,end),3,3)';

[uf,sf,vf] = svd(F_norm);
F_norm_prime = uf*diag([sf(1) sf(5) 0])*(vf');
F= norm_mat2' * F_norm_prime* norm_mat1;
