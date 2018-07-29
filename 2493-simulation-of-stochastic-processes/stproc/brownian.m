function [bmproc] = brownian(npoints, sigma)
% BROWNIAN generate and plot an aproximation to Brownian motion.
%   Generates a random walk with normally distributed jumps
%
% [bmproc] = brownian(npoints [, sigma])
%
% Inputs: npoints - length of the trajectory 
%         sigma - optional, the norming constant (standard
%         deviation of B(1)). Default 1.
%
% Outputs: bmproc - trajectory of the process

% Authors: R.Gaigalas, I.Kaj
% v1.2 04-Oct-02

  % set default parameter values
  if (nargin==1)
    sigma = 1;
  end

  % generate a sample from a Gaussian distribution and sum up
  bmproc = [0 cumsum(sigma.*randn(1, npoints-1))]; 

  % plot the process
  plot([0:npoints-1], bmproc);


