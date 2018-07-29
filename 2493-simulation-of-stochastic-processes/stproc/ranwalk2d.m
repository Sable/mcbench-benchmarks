function [rwproc] = ranwalk2d(npoints, p)
% RANWALK2D generate and plot the process (X(n), Y(n)), where
%   X and Y are random walks which start at 0, jump up with
%   probability p and down with probability 1-p 
%
% [rwproc] = ranwalk2d(npoints, p)
%
% Inputs: npoints - length of the trajectory 
%         p - probability of the jump upwards
%
% Outputs: rwproc - npoints x 2 matrix with values of the process

% Authors: R.Gaigalas, I.Kaj
% v1.2 07-Oct-02

  % default parameter values
  if (nargin==0)
    npoints = 1000;
    p = 0.5;
  end

  rwproc = [zeros(1, 2); cumsum(2.*(rand(npoints-1, 2)<p)-1)];
  
  % plot the process 
  stairs(rwproc(:, 1), rwproc(:, 2));

