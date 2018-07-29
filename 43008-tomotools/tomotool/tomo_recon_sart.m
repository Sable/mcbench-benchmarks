function im_rec = tomo_recon_sart(W, p, siz, n_it)
%TOMO_RECON_SART   Tomographic reconstruction using SART method.
%
%   Phymhan
%   08-Aug-2013 20:44:52

if nargin < 4
    n_it = 100;
end
%siz = size(im);
%[W, p, ~, ~] = buildWeightMatrix(im,angles);
f = sart_solve(W,p,n_it);
im_rec = reshape(f,siz);
end
