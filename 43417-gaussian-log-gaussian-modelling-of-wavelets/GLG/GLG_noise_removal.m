function [clean_tree, scaling_factor] = GLG_noise_removal( noisy_tree, theta, noise_dev, N )

% Noise removal in the GLG model
%
% Synax:
%	clean_tree = GLG_noise_removal( noisy_tree, theta, noise_dev, N )
%
%
% Input:
%	noisy_tree : Tree from DWT2_TO_TREE with noisy coefficients.
%
%   theta      : Parameter matrix for NOISY_TREE.
%
% 	noise_dev  : Standard dev of noise.
%
%	N 		   : Number of nodes to use in quadrature rule.
%
%
% Output:
%	clean_tree  : Cleaned wavelet coefficients.

[L, ~, D] = size(theta);
noise_var = noise_dev^2;

scaling_factor = noisy_tree(2:end);

% The low pass coefficients are not modified
clean_tree = noisy_tree;

% Gauss-Hermite weights and points
[nodes, weights] = hermite_quad(N);

joint_dens = @(s,w) exp( s - 0.5*w.^2./(exp(s) + noise_var) ) ./ (exp(s) + noise_var).^1.5;
marginal_dens = @(s,w) exp( -0.5*w.^2./(exp(s) + noise_var) ) ./ sqrt(exp(s) + noise_var);

% Compute scaling factor integral for each coefficient
for l = 1:L
    for d = 1:D
        mu = theta(l,1,d);
        sigma = theta(l,2,d);
        
        W = noisy_tree{l+1}{d}(:);
        no_w = numel(W);
        w_rep = repmat( W, 1, N );
        
        rep_nodes = repmat(nodes', no_w, 1);
        rep_weights = repmat(weights', no_w, 1);
        
        shifted_nodes = mu + sqrt(2)*sigma*rep_nodes;

        joint = sum( rep_weights .* joint_dens( shifted_nodes, w_rep ), 2 );
        marginal = sum( rep_weights .* marginal_dens( shifted_nodes, w_rep ), 2 );
        
        scaling_factor{l}{d} = reshape(joint ./ marginal, size(noisy_tree{l+1}{d}) );
        
        clean_tree{l+1}{d} = noisy_tree{l+1}{d} .* scaling_factor{l}{d};
    end
end

end
