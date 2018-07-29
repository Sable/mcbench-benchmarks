function [rwproc] = ranwalk(npoints, p)
% RANWALK generate and plot a trajectory of a random walk which
%    starts at 0, jumps up with probability p and down with
%    probability 1-p 
%
% [rwproc] = ranwalk(npoints, p)
%
% Inputs: npoints - length of the trajectory 
%         p - probability of the jump upwards
%
% Outputs: rwproc - trajectory of the process

% Authors: R.Gaigalas, I.Kaj
% v1.2 07-Oct-02

  % default parameter values
  if (nargin==0)
    npoints = 100;
    p = 0.5;
  end

  % generate jumps and sum up
  rwproc = [0 cumsum(2.*(rand(1, npoints-1)<p)-1)]; 

  stairs(rwproc);
