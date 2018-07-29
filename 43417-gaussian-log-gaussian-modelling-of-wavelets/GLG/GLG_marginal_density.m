function q = GLG_marginal_density( w, mu, sigma )

% Compute the marginal density of wavelet coefs in the GLG model
%
% Syntax:
%   q = marginal_density( w, mu, s^2 )
%
%
% Input:
%   w  : Row vector with input values of w
%
%   mu : Mean of hidden var
%
%   s  : Standard deviation of hidden var
%
%
% Output:
%   q  : The density q(w | mu, sigma^2) evaluated at w

% Marginal density in integral form
p = @(w) quadgk( @(s) joint_density(s, w, mu, sigma), -Inf, Inf );

[~, K] = joint_density(0, 0, mu, sigma);

% Evaluate marginal density
q = arrayfun( p, w ) * K;

end
