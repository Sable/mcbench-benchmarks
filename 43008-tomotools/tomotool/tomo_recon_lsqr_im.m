function im_rec = tomo_recon_lsqr_im(im, angles, tol, n_it)
%TOMO_RECON_LSQR_IM   Tomographic reconstruction using LSQR method.
%
%   Phymhan
%   09-Aug-2013 09:54:03

if nargin < 4
    n_it = 100;
    if nargin < 3
        tol = 1e-6;
    end
end
siz = size(im);
[W, p, ~, ~] = buildWeightMatrix(im,angles);
f = lsqr(W,p,tol,n_it);
im_rec = reshape(f,siz);
end
