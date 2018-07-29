function [bmproc] = bm3plot(npoints, sigma)
%
% BM3PLOT Generate and plot a 3-dimensional Brownian motion
%
% [bmproc] = brownian3d(npoints [, sigma])
%
% Inputs: npoints - length of the trajectory 
%         sigma - optional, the norming constant. Default 1.
%
% Outputs: bmproc - npoints x 3 matrix with values of the process

% Authors: R.Gaigalas, I.Kaj
% v1.2 04-Oct-02

  % set default parameter values
  if (nargin==1)
    sigma = 1;
  end

  % generate a 3-dimensional random walk with normally distributed
  % jumps
  bmproc = cumsum([zeros(1, 3); sigma^0.5*randn(npoints-1, 3)]);

  % plot the process 
  % first the trajectory in black
  plot3(bmproc(:, 1), bmproc(:, 2), bmproc(:, 3), 'k');

  % create colour matrices for every point
  p_col = (bmproc-repmat(min(bmproc), npoints, 1))./ ...
	  repmat(max(bmproc)-min(bmproc), npoints, 1);

  % plot the jump points as points in the colour cube
  % to get a "space" feeling 
  hold on;
  scatter3(bmproc(:, 1), bmproc(:, 2), bmproc(:, 3), ...
	   10, p_col, 'filled');
  grid on;
  hold off;

