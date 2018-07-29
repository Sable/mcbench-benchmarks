function im_rec = tomo_recon_fbp(projmat_bp,angles)
%TOMO_RECON_FBP   Tomographic reconstruction using Filtered Back Projection
%   (BP) algorithm.
%
%   Phymhan
%   05-Aug-2013 17:23:35

[n_proj,D] = size(projmat_bp);
if length(angles) ~= n_proj
    fprintf('Size of proj_mat is incorrect.\r')
    im_rec = [];
    return
end
im_rec = zeros(D);
for k = 1:n_proj
    proj_vec = hpf(projmat_bp(k,:));
    im_rot = repmat(proj_vec/D,D,1);
    im_rot = imrotate(im_rot, angles(k), 'bilinear', 'crop');
    %DEBUG
    % image(im_rot);
    % waitforbuttonpress
    % %
    im_rec = im_rec+im_rot/n_proj;
    %DEBUG
    % imagesc(im_rec)
    % waitforbuttonpress
    % %
end
end
