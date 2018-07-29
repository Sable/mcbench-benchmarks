function [rwproc] = ranwalk3d(npoints, p)
% RANWALK3D generate the process (X(n), Y(n), Z(n)),
%   where X, Y and Z are random walks which start at 0, jump up
%   with probability p and down with probability 1-p 
%
% [rwproc] = ranwalk3d(npoints, p)
%
% Inputs: npoints - length of the trajectory 
%         p - probability of the jump upwards
%
% Outputs: rwproc - npoints x 3 matrix with values of the process

% Authors: R.Gaigalas, I.Kaj
% v1.2 07-Oct-02

  % default parameter values
  if (nargin==0)
    npoints = 1000;
    p = 0.5;
  end

  rwproc = [zeros(1, 3); cumsum(2.*(rand(npoints-1, 3)<p)-1)];
  
  plot3(rwproc(:,1), rwproc(:,2), rwproc(:,3));
