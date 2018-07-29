function [theta, ll] = EM_tree( theta, w_parent, w_child, level, direction, N, max_itr, noise_dev, conv_thres, conv )

% The EM algorithm for the tree of the GLG model
% Performs one expectation and one maximization step in the EM algorithm
% for a 2D wavelet tree.
%
% Syntax:
%   [theta, ll] = EM_tree( theta, w_p, w_c, level, d, N, max_itr, noise, thres, conv )
%
% Input:
%   theta   : Current set of parameters.
%
%   w_p     : Column vector with parent coefficients
%
%   w_c     : Column vector with children coefficients
%
%   level   : Level of the wavelet transform. Minimum 2 (1 is low pass).
%
%   d       : Direction in the transform
%
%   N       : Number of points in quadrature rule
%
%   max_itr : Maximum number of EM iterations
%
%   noise   : Standard dev of noise
%
%   thres   : Convergence threshold for the log-likelihood function
%
%   conv    : How should THRES be applied: 'absolute' or 'relative'
%
%
% Output:
%   theta   : Updated set of parameters
%
%   ll      : Value of log-likelihood function with updated sigma
%
%
% See also: GLG_EM_wrapper

% Rearrange coefficients
[no_parent, d] = size(w_child);

rep_w_parent = repmat( w_parent, [1 N] );
rep_w_child = repmat( w_child, [1 1 N] );

count = 1;
ll_increase = Inf;
ll = zeros(max_itr, 1);

rel_conv = strcmpi(conv, 'relative');

% The parameters
mu    = theta(level-1, 1, direction);
sigma = theta(level-1, 2, direction);
alpha = theta(level, 3, direction);
beta  = theta(level, 4, direction);
kappa = theta(level, 5, direction);

% Gauss-Hermite weights and points
[nodes, weights] = hermite_quad(N);

rep_inner_nodes = repmat( reshape(nodes, [1 1 N]), [no_parent d 1] );

rep_outer_weights = repmat( weights', [no_parent 1] );
rep_inner_weights = repmat( reshape(weights, [1 1 N]), [no_parent d 1] );

% The density of the observations depends on the noise
if noise_dev == 0
    observed_dens = @(s,w) exp( -0.5*(w.^2.*exp(-s) + s) ) / (sqrt(2)*pi);
else
    noise_var = noise_dev^2;
    observed_dens = @(s,w) exp( -0.5*w.^2./(exp(s) + noise_var) ) ./ (pi*sqrt( 2*(exp(s) + noise_var) ));
end

[CM0, CM1, CM2, inner_moment1, inner_moment2] = deal( zeros(no_parent, d, N) );


while (count <= max_itr) && (ll_increase > conv_thres)
    % Inform user
    backsp = repmat( '\b', 1, numel(num2str(count-1)) );
    fprintf( [backsp '%u'], count);
    
    % ----------------------------------------------------------
    %                                                     E step
    % ----------------------------------------------------------
    %
    % Naming convention: HMnm is the expected value of s_parent^n*s_child^m
    % wrt the conditional density (s_p, s_c | w_p, w_c)
    %
    % CMn is an array with the n'th moment of all child variables.
    % inner_momentn is the product of the CM0's with one 2D array replaced
    % by the corresponding array from CMn
    
    % Nodes for outer integral
    outer_nodes = mu + sqrt(2)*sigma*nodes;
    rep_outer_nodes = repmat( outer_nodes', [no_parent 1] );
    
    % Inner integrals
    for k = 1:N
        inner_nodes = alpha + beta*outer_nodes(k) + sqrt(2)*kappa*rep_inner_nodes;
        OD = rep_inner_weights .* observed_dens( inner_nodes, rep_w_child );
        
        CM0(:,:,k) = sum( OD, 3 );
        
        GM_summand = inner_nodes .* OD;
        CM1(:,:,k) = sum( GM_summand, 3 );
        
        GM_summand = inner_nodes.^2 .* OD;
        CM2(:,:,k) = sum( GM_summand, 3 );
    end

    inner_moment0 = squeeze(prod(CM0,2));
    
    for j = 1:d
        tmp = CM0;
        
        tmp(:,j,:) = CM1(:,j,:);
        inner_moment1(:,j,:) = prod(tmp,2);
        
        tmp(:,j,:) = CM2(:,j,:);
        inner_moment2(:,j,:) = prod(tmp,2);
    end
    
    % Outer integrand
    parent_dens = rep_outer_weights .* observed_dens(rep_outer_nodes, rep_w_parent);
    outer_summand = parent_dens .* inner_moment0;
    
    % We do not normalize the integrals in the E step
    HM00 = sum( outer_summand, 2 );
    
    % ----------------------------------------------------------
    
    HM10 = sum(rep_outer_nodes .* outer_summand, 2) ./ HM00;
    
    parent_mean = mean( HM10 );
    
    % ----------------------------------------------------------
    
    HM20 = sum(rep_outer_nodes.^2 .* outer_summand, 2) ./ HM00;
    
    % ----------------------------------------------------------
    
    rep_parent_dens = repmat( reshape(parent_dens, [no_parent 1 N]), [1 d 1] );
    rep2_outer_nodes = repmat( reshape(rep_outer_nodes, [no_parent 1 N]), [1 d 1] );
    rep_HM00 = repmat( HM00, [1 d] );
    
    HM_summand = rep_parent_dens .* inner_moment1;
    HM01 = sum(HM_summand, 3) ./ rep_HM00;
    
    child_mean = mean( HM01(:) );
    
    % ----------------------------------------------------------
    
    HM_summand = rep_parent_dens .* inner_moment2;
    HM02 = sum(HM_summand, 3) ./ rep_HM00;
    
    % ----------------------------------------------------------
    
    HM_summand = rep2_outer_nodes .* rep_parent_dens .* inner_moment1;
    HM11 = sum(HM_summand, 3) ./ rep_HM00;
    
    
    % ----------------------------------------------------------
    %                                                     M step
    % ----------------------------------------------------------
    
    % Beta
    beta_numerator = sum( HM11(:) - parent_mean*HM01(:) );
    beta_denominator = d*sum(HM20 - parent_mean^2);
    beta = beta_numerator / beta_denominator;
    
    % alpha
    alpha = child_mean - beta*parent_mean;
    
    % kappa
    kappa2 = mean(HM02(:)) + beta^2*mean(HM20) - 2*beta*mean(HM11(:)) - alpha^2;
    kappa = sqrt(kappa2);
    

    % ----------------------------------------------------------
    %                                         Compute likelihood
    % ----------------------------------------------------------
    
    % Same calculations as above, but with the updated parameters
    
    % Nodes for outer integral
    outer_nodes = mu + sqrt(2)*sigma*nodes;
    rep_outer_nodes = repmat( outer_nodes', [no_parent 1] );
    
    % Inner integrals
    for k = 1:N
        inner_nodes = alpha + beta*outer_nodes(k) + sqrt(2)*kappa*rep_inner_nodes;
        OD = rep_inner_weights .* observed_dens( inner_nodes, rep_w_child );
        
        CM0(:,:,k) = sum( OD, 3 );
    end
    
    inner_moment0 = squeeze(prod(CM0,2));
    
    % Outer integrand
    parent_dens = rep_outer_weights .* observed_dens(rep_outer_nodes, rep_w_parent);
    outer_summand = parent_dens .* inner_moment0;
    
    % We do not normalize the integrals in the E step
    HM00 = sum( outer_summand, 2 );
    
    
    % With numerically large parameters HM00 can become negative when using too
    % crude approximations in the numerical intergrals
    if any( HM00(:) < 0 )
        error('EM_tree_spline:NegativeLikelihood', 'Likelihood is negative.\nTry using a larger number of nodes');
    end
    
    ll(count) = sum( log(max(HM00(:), eps)) );
    
    % ----------------------------------------------------------
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

theta(level, 1, direction) = alpha + beta*mu;
theta(level, 2, direction) = sqrt( kappa2 + (beta*sigma)^2 );
theta(level, 3, direction) = alpha;
theta(level, 4, direction) = beta;
theta(level, 5, direction) = kappa;

end

