% A fast and simple voxel traversal algorithm through a 3D space partition (grid)
% proposed by J. Amanatides and A. Woo (1987).

% % Test Nro. 1
origin    = [15, 15, 15]';
direction = [-0.3, -0.5, -0.7]';

% % Test Nro. 2
%origin    = [-8.5, -4.5, -9.5]';
%direction = [0.5, 0.5, 0.7]';

% Grid: dimensions
grid3D.nx = 10;
grid3D.ny = 15;
grid3D.nz = 20;
grid3D.minBound = [-10, -10, -20]';
grid3D.maxBound = [ 10,  10,  20]';

verbose = 1;
amanatidesWooAlgorithm(origin, direction, grid3D, verbose);
