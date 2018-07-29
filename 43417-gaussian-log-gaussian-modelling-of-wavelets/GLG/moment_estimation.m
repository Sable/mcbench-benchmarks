function theta = moment_estimation( M, default_beta, default_dev )

% Parameter estimates from moment equations
% Note that parameter estimation is bad for small data sets: The
% variances can be negative and the beta's are numerically too large.
%
% Syntax:
%   E = moment_estimation( M, n_dev[, def_b, max_v] )
%
% Input:
%   M       : Matrix with moments from compute_moments.
%
%   def_b   : If beta is estimated to be negative or too large it is 
%             replaced by DEF_B
%			  Default: 1
%
%   def_std : If sigma and kappa are estimated to be negative they are
%             replaced by STD_VAL.
%             Default: 0.5
%
%
% Output:
%   theta : L-by-5-by-D matrix where L is the number of levels in the
%           wavelet transform, D is the number of directions and the
%           (l+1)'th row is estimates of
%           mu_l, sigma_l, alpha_l, beta_l, kappa_l
%
% See also: COMPUTE_MOMENTS

% Default values
if ~exist( 'default_beta', 'var' )
    default_beta = 1;
end

if ~exist( 'std_val', 'var' )
    default_dev = 0.5;
end

% Preallocate output
L = size(M, 1) - 1;
theta = zeros( L+1, 5, size(M,3) );

% Indices for beta's, alpha's and kappa's
idx = 1:L;

% sigma's
sigma2 = log(M(:,2,:)/3) - 2*log(M(:,1,:));
theta(:, 2, :) = sqrt( sigma2 );

% mu's
theta(:, 1, :) = log(M(:,1,:)) - sigma2/2;

% TODO: Is there a good way to test if the beta estimate is too large

% beta's
theta(1+idx, 4, :) = ( log(M(1+idx,3,:)) - 2*log(M(1+idx,1,:)) ) ./ ...
    ( log(M(idx,4,:)) - log(M(1+idx,1,:)) - log(M(idx,1,:)) );

% Restrict large beta's
beta_idx = false( size(theta) );
beta_idx(1+idx, 4, :) = true;

positive_idx = real(theta) > 2;
negative_idx = real(theta) < 0;

theta( beta_idx & (positive_idx | negative_idx) ) = default_beta;

% alpha's
theta(1+idx, 3, :) = theta(1+idx, 1, :) - theta(1+idx, 4, :).*theta(idx, 1, :);

% kappa's
kappa2 = sigma2(1+idx, :, :) - theta(1+idx, 4, :).^2 .* sigma2(idx, :, :);
theta(1+idx, 5, :) = sqrt( kappa2 );


% ---------------------------------------------------------------------- 
%
% If any of the variances are estimated to be negative, we estimate 
% parameters in the homogeneous GLG model

ind = find( imag(theta) );
[~, ~, D] = ind2sub( size(theta), ind );
D = unique( D );

if isempty(D)
    return
end

mu    = theta(1,1,:);
sigma = theta(1,2,:);
alpha = theta(2,3,:);
beta  = theta(2,4,:);
kappa = theta(2,5,:);

% Default values
sigma( imag(sigma) ~= 0 ) = default_dev;
kappa( imag(kappa) ~= 0 ) = default_dev;
alpha( imag(alpha) ~= 0 ) = -default_beta;
beta( imag(beta) ~= 0 )   = default_beta;

homogeneous_theta = homogeneous_to_full_GLG( L+1, mu, sigma, alpha, beta, kappa );
theta(:,:,D) = homogeneous_theta(:,:,D);

end
