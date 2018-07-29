function im_rec = tomo_recon_myart_im(im, angles, n_it)
%TOMO_RECON_ART_IM   Tomographic reconstruction using ART method.
%
%   Phymhan
%   09-Aug-2013 09:15:41

if nargin < 3
    n_it = 100;
end
siz = size(im);
[W, p, ~, ~] = buildWeightMatrix(im,angles);
f = myart_solve(W,p,n_it);
im_rec = reshape(f,siz);
end
