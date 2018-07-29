%% 
% Demo script illustrating how to experiment with tomographic
% reconstruction using tomobox
%
% Set up 3D test image
% Choose a number of random projection directions
% Set up the parallel beam system matrix
% Compute projections
% Add Gaussian noise
% Reconstruct

% Jakob Heide Jørgensen (jakj@imm.dtu.dk)
% Department of Informatics and Mathematical Modelling (IMM)
% Technical University of Denmark (DTU)
% August 2010

% This code is released under the Gnu Public License (GPL). 
% For more information, see
% http://www.gnu.org/copyleft/gpl.html


clear
close all
clc

%% Dimensions to use in simulation
r1_max   = 17;
N        = 2*r1_max+1;      % 3D image side length
dims     = N*[1,1,1];
u_max    = 23;              % Projection side length
nuv      = [1,1];           % Number of subpixels, see buildSystemMatrix
vpRatio  = 1;               % Voxel-to-pixel ratio, see buildSystemMatrix
num_proj = 30;              % Number of projections to reconstruct from
rnl      = 0.01;            % Relative noise level

%% Set up 3D test image
X_true = phantom3d('Modified Shepp-Logan',N);
x_true = X_true(:);

%% Choose a number of random projection directions

% Choose x,y,z as Gaussian triple and normalize. Since Gaussians are
% rotation-symmetric, the directions obtained are samples from the uniform
% distribution over the unit sphere.
v_list     = randn(num_proj,3);
v_listnorm = sqrt(sum(v_list.^2,2));
v_list     = v_list./repmat(v_listnorm,1,3);

%% Set up the parallel beam system matrix
[A,p_all] = buildSystemMatrix(r1_max,u_max,v_list,nuv,vpRatio);

%% Compute projections
b_orig = A*x_true;

%% Add Gaussian noise
e = getNoise(rnl,b_orig);
b = b_orig + e;
B = reshape(b,2*u_max+1,2*u_max+1,num_proj);

%% Reconstruct
tol = 1e-6;
maxit = 200;
x_sol = lsqr(A,b,tol,maxit);
X_sol = reshape(x_sol,dims);
%% Display

figure
plotLayers(X_true)
suptitle('Original')

figure
plotLayers(B)
suptitle('Projections')

figure
plotLayers(X_sol)
suptitle(['Reconstruction, iteration ',num2str(maxit)])