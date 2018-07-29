function t = mlrnd(beta, gamma_t, m, n)

% mlrnd.m: Mittag-Leffler pseudo-random number generator
%
% Authors: Guido Germano, Daniel Fulger, Enrico Scalas (2006-2008)
%
% Description: Returns a matrix of iid random numbers distributed according to
% the one-parameter Mittag-Leffler distribution with index (or exponent) beta
% and scale parameter gamma_t. The size of the returned matrix is the same as
% that of the input matrices beta and gamma_t, that must match. Alternatively,
% if beta and gamma_t are scalars, mlrnd(beta, gamma_t, m) returns an m by m
% matrix, and mlrnd(beta, gamma_t, m, n) returns an m by n matrix.
%
% References:
% [1] T. J. Kozubowski and S. T. Rachev, "Univariate Geometric Stable Laws"
%     Journal of Computational Analysis and Applications 1, 177-219 (1999).
% [2] D. Fulger, E. Scalas, G. Germano, "Monte Carlo simulation of uncoupled
%     continuous-time random walks yielding a stochastic solution of the space-
%     time fractional diffusion equation", Physical Review E 77, 021122 (2008).

% Check input
if nargin < 2
    error('mlrnd requires at least two arguments.')
elseif nargin == 2
    sb = size(beta);
    sg = size(gamma_t);
    if ~isscalar(beta) && ~isscalar(gamma_t) && any(sb ~= sg)
        error('mlrnd: size mismatch between beta and gamma_t.')
    end
    m = max(sb(1),sg(1));
    n = max(sb(2),sg(2));
else
    if ~isscalar(beta) && ~isscalar(gamma_t)
        error('mlrnd: beta and gamma_t must be scalars when m is given.')
    end
    if ~(isscalar(m) && m > 0 && m == round(m))
        error('mlrnd: m must be a positive integer.')
    end
    if nargin == 3
        n = m;
    elseif ~(isscalar(n) && n > 0 && n == round(n))
        error('mlrnd: n must be a positive integer.')
    end
end
if any(any(beta <= 0)) || any(any(beta > 1))
    error('mlrnd: the elements of beta must belong to the interval (0,1].')
end
if any(any(gamma_t <= 0))
    error('mlrnd: the elements of gamma_t must be positive.')
end

% Generate m x n Mittag-Leffler pseudo-random numbers
t = -log(rand(m,n)); % Standard exponential deviate
if (beta < 1)
    u = rand(m,n); % Uniform deviate on the unit interval, independent of t
    w = sin(beta*pi)./tan(beta*pi.*u) - cos(beta*pi); % Auxiliary variable
    t = t.*w.^(1./beta); % Standard one-parameter Mittag-Leffler deviate
end
t = gamma_t*t;

return
