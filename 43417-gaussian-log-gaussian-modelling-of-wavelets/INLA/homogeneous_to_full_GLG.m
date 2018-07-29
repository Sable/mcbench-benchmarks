function theta = homogeneous_to_full_GLG( L, mu, sigma, alpha, beta, kappa )

% Compute full parameter set from parameters from INLA
% The homogeneus GLG model used in INLA only contains five parameters; this
% function computes the remaining parameters in the 'full' GLG model.
%
% Syntax:
%   theta = homogeneus_to_full_GLG( L, mu, sigma, alpha, beta, kappa )
%
% Input:
%   L     : The number of levels in the transform
%
%   mu    : Mean of root node
%
%   sigma : Standard dev of root node
%
%   alpha : Intercept of transitions
%
%   beta  : Slope of transitions
%
%   kappa : Standard dev of transitions
%
% The dimension of the parameters determines the number of dimensions.
% If a parameters is empty, a value is picked at random.
%
%
% Output:
%   theta : A matrix with the full parameter set


% ----------------------------------------------------------------------
%                                               Fill in empty parameters
% ----------------------------------------------------------------------

if nargin == 1
    [mu, sigma, alpha, beta, kappa] = deal( [] );
end

parameters = {mu, sigma, alpha, beta, kappa};
dims = cellfun(@numel, parameters);

missing_vals = cellfun(@isempty, parameters);

% The default number of dimensions is 3
if all(missing_vals)
    D = 3;
else
    D = dims( find(dims, 1) );
end

% Simulate missing values
for j = find(missing_vals)
    switch j
        case {1, 3}
            parameters{j} = -1 + 2*rand(D, 1);
            
        case {2, 4, 5}
            parameters{j} = rand(D, 1);
    end
end

[mu, sigma, alpha, beta, kappa] = deal( parameters{:} );


% ----------------------------------------------------------------------
%                                                     Compute full theta
% ----------------------------------------------------------------------

theta = zeros(L, 5, D);

theta(1, 1, :) = mu;
theta(1, 2, :) = sigma;

% All alpha's, beta's and kappa's are the same
theta(2:end, 3, :) = repmat( reshape(alpha, [1 1 D]), [L-1 1 1] );
theta(2:end, 4, :) = repmat( reshape(beta, [1 1 D]), [L-1 1 1] );
theta(2:end, 5, :) = repmat( reshape(kappa, [1 1 D]), [L-1 1 1] );

% Compute remaining mu's and sigma's
for l = 2:L
    for d = 1:D
        if beta(d) == 1
            theta(l,1,d) = alpha(d)*(l-1) + mu(d);
            
            sigma2 = kappa(d)^2*l + sigma(d)^2;
            theta(l,2,d) = sqrt( sigma2 );
        else
            theta(l,1,d) = alpha(d)*(beta(d)^(l-1)-1)/(beta(d)-1) + beta(d)^(l-1)*mu(d);
            
            sigma2 = kappa(d)^2*(beta(d)^(2*(l-1))-1)/(beta(d)^2-1) + beta(d)^(2*(l-1))*sigma(d)^2;
            theta(l,2,d) = sqrt( sigma2 );
        end
    end
end

end
