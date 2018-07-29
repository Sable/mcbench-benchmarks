function [y, C] = noisy_joint_density(s, w, mu, sigma, noise_dev)

% Evaluate the joint density of hidden and observed variables
% Note that the joint density is *not* normalized, i.e., it is only
% evaluated up to proportionality. This is because it can assume Inf values
% if mu << 0 and sigma >> 0 and the proportionalty factor is not needed in
% the EM algorithm.
%
% Syntax:
%   [y, C] = joint_density(s, w, mu, sd, sn)
%
% Input:
%   s  : Value of hidden variable.
%
%   w  : Value of wavelet coefficient. Must have the same size as s
%
%   mu : Mean of hidden variable.
%
%   sd : Standard deviation of hidden variable.
%
%   sn : Standard deviation of noise.
%
%
% Output:
%   y  : Value of density
%
%   C  : Normalizing factor for density.
%
% See also: JOINT_DENSITY

if isscalar(w)
    w2 = w^2 * ones(size(s));
else
    w2 = w.^2;
end

% The 'upper' exponential
logy = -0.5*((s - mu)/sigma).^2;

non_zero_idx = w2 ~= 0;
observed_var = exp(s) + noise_dev^2;
logy(non_zero_idx) = logy(non_zero_idx) ...
    - 0.5*w2(non_zero_idx)./observed_var(non_zero_idx);


y = exp( logy ) ./ sqrt(observed_var);

% The normalization factor
if nargout == 2
	C = 1/(2*pi*sigma);
end

end
