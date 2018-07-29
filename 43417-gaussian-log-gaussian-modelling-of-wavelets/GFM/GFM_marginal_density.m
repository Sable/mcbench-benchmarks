function q = GFM_marginal_density( w, p, sigma )

% Compute the marginal density of wavelet coefs in the GFM model
%
% Syntax:
%   q = marginal_density( w, p, s^2 )
%
% Input:
%   w : Row vector with input values of w
%
%   p : Mean of hidden var
%
%   s : Standard deviation of hidden var
%
%
% Output:
%   q : The density q(w | p, sigma^2) evaluated at w

% The number of mixtures
M = numel( sigma );

% The number of observations
no_w = numel( w );

% Marginal density
w = reshape( w, [1 no_w] );
p = reshape( p, [M 1] );
sigma = reshape( sigma, [M 1] );

q = sum( normpdf( repmat(w, [M 1]), 0, repmat(sigma, [1 no_w]) ) .* repmat(p, [1 no_w]) );

end
