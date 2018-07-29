function im_rec = tomo_recon_lsqr(W, p, siz, tol, n_it)
%TOMO_RECON_LSQR   Tomographic reconstruction using LSQR method.
%
%   Phymhan
%   09-Aug-2013 09:53:51

if nargin < 5
    n_it = 100;
    if nargin < 4
        tol = 1e-6;
    end
end
%siz = size(im);
%[W, p, ~, ~] = buildWeightMatrix(im,angles);
f = lsqr(W,p,tol,n_it);
im_rec = reshape(f,siz);
end
