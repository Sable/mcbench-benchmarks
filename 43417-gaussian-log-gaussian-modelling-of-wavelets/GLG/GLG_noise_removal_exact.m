function [clean_tree, scaling_factor] = GLG_noise_removal_exact( noisy_tree, theta, noise_dev )

% Noise removal in the GLG model
%
% Synax:
%	clean_tree = GLG_noise_removal( noisy_tree, theta, noise_dev )
%
%
% Input:
%	noisy_tree : Tree from DWT2_TO_TREE with noisy coefficients.
%
%   theta      : Parameter matrix for NOISY_TREE.
%
% 	noise_dev  : Standard dev of noise.
%
%
% Output:
%	clean_tree  : Cleaned wavelet coefficients.

[L, ~, D] = size(theta);
noise_var = noise_dev^2;

scaling_factor = noisy_tree(2:end);

% The low pass coefficients are not modified
clean_tree = noisy_tree;

% Compute scaling factor integral for each coefficient
for l = 1:L
    fprintf('Level %u: ', l);
    
    for d = 1:D
        fprintf('%u ', d);
        
        mu = theta(l,1,d);
        sigma = theta(l,2,d);
        
        W = noisy_tree{l+1}{d};
        
        joint = @(w) quadgk( @(s) exp(s) ./ (exp(s) + noise_var) .* noisy_joint_density(s, w, mu, sigma, noise_dev), -Inf, Inf );
        marginal = @(w) quadgk( @(s) noisy_joint_density(s, w, mu, sigma, noise_dev), -Inf, Inf );
        
        scaling_factor{l}{d} = arrayfun( joint, W ) ./ arrayfun( marginal, W );
        
        clean_tree{l+1}{d} = noisy_tree{l+1}{d} .* scaling_factor{l}{d};
    end
    
    fprintf('\n');
end

end
