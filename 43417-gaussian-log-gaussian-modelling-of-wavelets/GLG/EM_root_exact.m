function [theta, ll] = EM_root_exact( theta, tree, direction )

% The EM algorithm for the top level of the GLG model for 1D signals
% Performs one expectation and one maximization step in the EM algorithm
% for the top level of a wavelet tree.
%
% Syntax:
%   [theta, ll] = EM_root_exact( theta, tree, d )
%
% Input:
%   theta : Current set of parameters
%
%   tree  : Cell with wavelet coefficients
%
%   d     : Direction in the transform
%
%
% Output:
%   theta : Updated set of parameters
%
%   ll    : Value of log-likelihood function with updated parameters
%
% See also: GLG_EM_WRAPPER

% The current parameters
mu    = theta(1,1,direction);
sigma = theta(1,2,direction);

w = tree{2}{direction}(:)';

observed_density = @(w) quadgk( @(s) joint_density(s, w, mu, sigma), -Inf, Inf );
observed_values = arrayfun(observed_density, w);

% The first and second moments of the hidden variables
hidden_moment1 = @(w) quadgk( @(s) s .* joint_density(s, w, mu, sigma), -Inf, Inf );
hidden_moment2 = @(w) quadgk( @(s) s.^2 .* joint_density(s, w, mu, sigma), -Inf, Inf );

% New parameter estimates
hidden_moment1_estimates = arrayfun(hidden_moment1, w) ./ observed_values;
hidden_moment2_estimates = arrayfun(hidden_moment2, w) ./ observed_values;

theta(1,1,direction) = mean( hidden_moment1_estimates );
sigma2 = mean( hidden_moment2_estimates ) - theta(1,1,direction)^2;
theta(1,2,direction) = sqrt( sigma2 );

% Evaluate the log-likelihood function of the new parameter estimates
[~, C] = joint_density( 0, 0, theta(1,1,direction), theta(1,2,direction) );
observed_density = @(w) quadgk( @(s) joint_density(s, w, theta(1,1,direction), theta(1,2,direction)), -Inf, Inf );
ll = sum( log(C*arrayfun(observed_density, w)) );

end
