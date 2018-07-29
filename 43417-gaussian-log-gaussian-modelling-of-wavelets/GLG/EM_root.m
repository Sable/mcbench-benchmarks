function [theta, ll] = EM_root( theta, w, direction, N, max_itr, noise_dev, conv_thres, conv )

% The EM algorithm for the top level of the GLG model for 1D signals
% Performs one expectation and one maximization step in the EM algorithm
% for the top level of a wavelet tree.
%
% Syntax:
%   [theta, ll] = EM_root_exact( theta, tree, d, N, epsilon, max_itr, thres, conv )
%
% Input:
%   theta : Current set of parameters
%
%   w       : Column vector with wavelet coefficients
%
%   d       : Direction in the transform
%
%   N       : Number of points in quadrature rule
%
%   max_itr : Maximum number of EM iterations
%
%   thres   : Convergence threshold for the log-likelihood function
%
%   conv    : How should CONV_THRES be applied: 'absolute' or 'relative'
%
%
% Output:
%   theta : Updated set of parameters
%
%   ll    : Values of log-likelihood function through the iterations
%
% See also: GLG_EM_WRAPPER

no_w = numel(w);
w_rep = repmat( w, 1, N );

count = 1;
ll_increase = Inf;
ll = zeros(max_itr, 1);

rel_conv = strcmpi(conv, 'relative');

% The parameters
mu    = theta(1,1,direction);
sigma = theta(1,2,direction);

% Gauss-Hermite weights and points
[nodes, weights] = hermite_quad(N);
rep_nodes = repmat(nodes', no_w, 1);
rep_weights = repmat(weights', no_w, 1);

% The density of the observations depends on the noise
if noise_dev == 0
    observed_dens = @(s,w) exp( -0.5*(w.^2.*exp(-s) + s) ) / (sqrt(2)*pi);
else
    noise_var = noise_dev^2;
    observed_dens = @(s,w) exp( -0.5*w.^2./(exp(s) + noise_var) ) ./ (pi*sqrt( 2*(exp(s) + noise_var) ));
end

while (count <= max_itr) && (ll_increase > conv_thres)
    % Inform user
    backsp = repmat( '\b', 1, numel(num2str(count-1)) );
    fprintf( [backsp '%u'], count);
    
    
    % ------------------------------------------------------------
    %                                                       E step
    % ------------------------------------------------------------
    
    shifted_nodes = mu + sqrt(2)*sigma*rep_nodes;
    OD = observed_dens( shifted_nodes, w_rep );
    
    HM0 = sum( rep_weights .* OD, 2 );
    HM1 = sum( rep_weights .* shifted_nodes .* OD, 2 );
    HM2 = sum( rep_weights .* shifted_nodes.^2 .* OD, 2 );
    
    
    % ------------------------------------------------------------
    %                                                       M step
    % ------------------------------------------------------------
    
    hidden_moment1_estimates = HM1 ./ HM0;
    hidden_moment2_estimates = HM2 ./ HM0;
    
    mu = mean( hidden_moment1_estimates );
    sigma2 = mean( hidden_moment2_estimates ) - mu^2;
    sigma = sqrt( sigma2 );
    
    
    % ------------------------------------------------------------
    %                                       Compute log-likelihood
    % ------------------------------------------------------------
    
    % Compute normalized density with new parameteres
    OD = observed_dens( mu + sqrt(2)*sigma*rep_nodes, w_rep );
    HM0 = sum( rep_weights .* OD, 2 );
    
    ll(count) = sum( log(max(HM0, eps)) );
    
    
    % ------------------------------------------------------------
    % Update conditions for while loop
    
    if count > 1
        ll_increase = abs(ll(count) - ll(count-1));
        
        if rel_conv
            ll_increase = ll_increase / abs(ll(count-1));
        end
    end
    
    count = count + 1;
end

% Final values
ll = ll(1:count-1);
theta(1,1,direction) = mu;
theta(1,2,direction) = sigma;

end
