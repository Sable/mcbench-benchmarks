function [y, C] = joint_density(s, w, mu, sigma)

% Evaluate the joint density of hidden and observed variables
% Note that the joint density is *not* normalized, i.e., it is only
% evaluated up to proportionality. This is because it can assume Inf values
% if mu << 0 and sigma >> 0 and the proportionalty factor is not needed in
% the EM algorithm.
%
% Syntax:
%   [y, C] = joint_density(s, w, mu, sd)
%
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
%
% Output:
%   y  : Value of density
%
%   C : Normalization constant of y

if isscalar(w)
    w2 = w^2 * ones(size(s));
else
    w2 = w.^2;
end

% The common exponential term
logy = -0.5*((s - mu + sigma.^2/2)/sigma).^2;

% When w == 0 the term w^2*exp(-s) is still significant for large negative
% values of s
non_zero_idx = w2 ~= 0;

logy(non_zero_idx) = logy(non_zero_idx) ...
    - 0.5*w2(non_zero_idx).*exp(-s(non_zero_idx));

% The final value
y = exp( logy );

% The normalization factor
if nargout == 2
	C = exp( -mu/2 + sigma.^2/8 ) ./ (2*pi*sigma);
end

end
