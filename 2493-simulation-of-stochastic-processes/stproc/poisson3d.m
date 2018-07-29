function [pproc] = poisson3d(lambda)
% POISSON3D generate and plot Poisson process in the unit cube
% 
% [pproc] = poisson3d(lambda)
%
% Inputs: lambda - intensity of the process
%
% Outputs: pproc - a matrix with 3 columns with coordinates of the
%          points of the process

% Authors: R.Gaigalas, I.Kaj
% v1.2 07-Oct-02

  % the number of points is Poisson(lambda)-distributed
  npoints = poissrnd(lambda);

  % conditioned that the number of points is N,
  % the points are uniformly distributed
  pproc = rand(npoints, 3);

  % plot the process
  scatter3(pproc(:, 1), pproc(:, 2), pproc(:, 3), ...
           5, 5*rand(1, npoints));
  
  % create colour matrices for every point
%  p_col = (pproc-repmat(min(pproc), npoints, 1))./ ...
%	  repmat(max(pproc)-min(pproc), npoints, 1);
  
  % plot the points as points in the colour cube
  % to get a "space" feeling 
%  grid on;
%  scatter3(pproc(:, 1), pproc(:, 2), pproc(:, 3), ...
%           5, p_col);


