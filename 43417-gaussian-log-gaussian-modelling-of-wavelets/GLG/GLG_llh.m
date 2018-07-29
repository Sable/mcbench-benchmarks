function llh = GLG_llh( theta, tree, N )

% Evaluate the (composite) likelihood of data under the estimated GLG model
% This is *exactly* the same procedure for likelihood computation as in
% EM_ROOT and EM_TREE
%
% Syntax:
%   lh = GLG_llh( theta, tree[, N] )
%
%
% Input:
%   theta : Parameter matrix for GLG model.
%
%   tree  : Wavelet tree from DWT2_TO_CELL
%
%   N     : The number of nodes for quadrature rule
%
%
% Output:
%   llh   : Matrix with composite likelihood value for each level and
%           direction

no_levels = numel(tree) - 1;
llh = Inf( no_levels, 3 );

if size(theta, 1) ~= no_levels
    error('Wavelet transform must have the same size as theta');
end

% Gauss-Hermite weights and points
if nargin == 2
    N = 20;
end
[nodes, weights] = hermite_quad(N);

observed_dens = @(s,w) exp( -0.5*(w.^2.*exp(-s) + s) ) / (sqrt(2)*pi);


% --------------------------------------------------------------------
%                                             Likelihood for top level
% --------------------------------------------------------------------

no_w = numel(tree{2}{1});

rep_nodes = repmat(nodes', no_w, 1);
rep_weights = repmat(weights', no_w, 1);

for direction = 1:3
    w = tree{2}{direction}(:);
    w_rep = repmat( w, 1, N );
    
    % The parameters
    mu    = theta(1,1,direction);
    sigma = theta(1,2,direction);
    
    % Compute normalized density with new parameteres
    OD = observed_dens( mu + sqrt(2)*sigma*rep_nodes, w_rep );
    lh = sum( rep_weights .* OD, 2 );
    
    llh(1, direction) = sum( log(max(lh, eps)) );
end


% --------------------------------------------------------------------
%                                          Likelihood for lower levels
% --------------------------------------------------------------------

for level = 2:no_levels
    for direction = 1:3
        % Parameters for likelihood
        mu    = theta(level-1, 1, direction);
        sigma = theta(level-1, 2, direction);
        alpha = theta(level, 3, direction);
        beta  = theta(level, 4, direction);
        kappa = theta(level, 5, direction);
        
        % Arrange coefficients
        w_parent = tree{level}{direction}(:);
        
        % For images!
        w_child = zeros( numel(w_parent), 4 );
        w_child(:,1) = reshape( tree{level+1}{direction}(1:2:end, 1:2:end), 1, [] );
        w_child(:,2) = reshape( tree{level+1}{direction}(1:2:end, 2:2:end), 1, [] );
        w_child(:,3) = reshape( tree{level+1}{direction}(2:2:end, 1:2:end), 1, [] );
        w_child(:,4) = reshape( tree{level+1}{direction}(2:2:end, 2:2:end), 1, [] );
        
        % Prepare for the sums
        rep_w_parent = repmat( w_parent, [1 N] );
        rep_w_child = repmat( w_child, [1 1 N] );
        
        [no_parent, d] = size(w_child);
        CM0 = zeros(no_parent, d, N);
        
        rep_inner_nodes = repmat( reshape(nodes, [1 1 N]), [no_parent d 1] );
        
        rep_outer_weights = repmat( weights', [no_parent 1] );
        rep_inner_weights = repmat( reshape(weights, [1 1 N]), [no_parent d 1] );
        
        
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
        
        % Likelihood
        lh = sum( outer_summand, 2 );
        llh(level, direction) = sum( log(max(lh(:), eps)) );
    end
end

end
