function clean_tree = GFM_noise_removal( noisy_tree, theta, noise_level )

% Noisy removal in the GFM model
%
% Synax:
%	clean_tree = GFM_noise_removal( noisy_tree, noise_level )
%
% Input:
%	noisy_tree  : Tree from DWT2_TO_TREE with noisy coefficients.
%
%   theta       : Parameter cell for NOISY_TREE.
%
% 	noise_level : Standard dev of noise.
%
%
% Output:
%	clean_tree  : Cleaned wavelet coefficients.

% Estimate the noise free standard dev
noise_free_std = cellfun( @(x) max(x.^2 - noise_level.^2, 0), theta(:,3,:), 'uniformoutput', false );

% Compute the scaling factor of Crouse et al for the coefficients
std_ratio = cellfun( @(x,y) x ./ y.^2, noise_free_std, theta(:,3,:), 'uniformoutput', false );
scaling_factor = squeeze(cellfun( @(x,y) sum(x .* y), std_ratio, theta(:,1,:), 'uniformoutput', false ));

% The low pass coefficients are not modified
clean_tree = noisy_tree;

for j = 2:length(clean_tree)
    clean_tree{j} = cellfun( @(x,y) x * y, noisy_tree{j}, scaling_factor(j-1,:), 'uniformoutput', false );
end

end
