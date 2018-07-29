function [pjump] = poissonjp(njumps, lambda, ntraj)
% POISSONJP generate and plot a number of trajectories of a Poisson
%   process with a given number of jumps
%
% [pjump] = poissonjp(njumps, lambda [, ntraj])
%
% Inputs: njumps - number of jumps to generate in each trajectory
%         lambda - arrival intensity
%         ntraj - optional, the number of trajectories to
%           generate. Default 1.
%
% Outputs: pjump - a matrix with <ntraj> columns of jump times of
%            the processes
%
% See also POISSONTI

% Authors: R.Gaigalas, I.Kaj
% v1.2 07-Oct-02

  % default parameter values
  if (nargin ==2)
    ntraj = 1;
  end

  % generate a sample from Exp(lambda) and sum up 
  pjump = cumsum(-log(rand(njumps, ntraj))./lambda);

  % plot the first process
  stairs(pjump(:, 1), [0:njumps-1]);

