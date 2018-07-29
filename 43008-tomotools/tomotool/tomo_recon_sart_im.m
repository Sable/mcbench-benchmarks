function im_rec = tomo_recon_sart_im(im, angles, n_it)
%TOMO_RECON_SART_IM   Tomographic reconstruction using SART method.
%
%   Phymhan
%   09-Aug-2013 09:16:25

if nargin < 3
    n_it = 100;
end
siz = size(im);
[W, p, ~, ~] = buildWeightMatrix(im,angles);
f = sart_solve(W,p,n_it);
im_rec = reshape(f,siz);
end
