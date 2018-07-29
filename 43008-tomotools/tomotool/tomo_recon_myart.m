function im_rec = tomo_recon_myart(W, p, siz, n_it)
%TOMO_RECON_ART   Tomographic reconstruction using ART method.
%
%   Phymhan
%   08-Aug-2013 22:39:35

if nargin < 4
    n_it = 100;
end
%siz = size(im);
%[W, p, ~, ~] = buildWeightMatrix(im,angles);
f = myart_solve(W,p,n_it);
im_rec = reshape(f,siz);
end
