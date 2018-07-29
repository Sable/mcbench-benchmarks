function [ q, g, h, r ] = boundaryFileClampedPlate( p, e, u, time )
%BOUNDARYFILECLAMPEDPLATE Boundary conditions for heatTransferThinPlateExample
%   [ q, g, h, r ] = BOUNDARYFILECLAMPEDPLATE( p, e, u, time ) returns the
%   Neumann BC (q, g) and Dirichlet BC (h, r) matrices for the
%   clampedSquarePlateExample example. 
%   p is the point matrix returned from INITMESH
%   e is the edge matrix returned from INITMESH
%   u is the solution vector (used only for nonlinear cases)
%   time (used only for parabolic and hyperbolic cases)
%
%   See also PDEBOUND, INITMESH

%   Copyright 2012 The MathWorks, Inc.

N = 2;
ne = size(e,2);
% Apply a shear force along the boundary due to the transverse
% deflection of stiff, distributed springs
k = 1e7; % spring stiffness
q = [0 k 0 0]'*ones(1,ne);
g = zeros(N, ne);
h = zeros(N^2, 2*ne);
r = zeros(N, 2*ne);

end

