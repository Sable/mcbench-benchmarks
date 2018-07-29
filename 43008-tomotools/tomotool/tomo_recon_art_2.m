function im_rec = tomo_recon_art_2(projmat_art,angles,n_iter)
%TOMO_RECON_ART_2   Tomographic reconstruction using Algebraic 
%   Reconstruction Techniques(ART) in x and y directions.
%   projmat_art is a n times 2*D matrix, so as for tomo_recon_art, proj_mat
%   cannot be directly computed from tomoproj2d.
%
%   Phymhan
%   05-Aug-2013 17:58:21

if nargin < 3
    n_iter = 10;
end
[n_proj,L] = size(projmat_art);
D = floor(L/2);
if length(angles) ~= n_proj
    fprintf('Size of proj_mat is incorrect.\r')
    im_rec = [];
    return
end
%ang_diff = -diff([0 angles(:)']);
%SumO = sum(projmat_art(1,1:D));
%imG = SumO/D^2*ones(D);
im_rec = zeros(D);
for k = 1:n_proj
    %Adjust direction of projmat
    %cSumO = repmat(projmat_art(k,  1: 1:  D) ,D,1);
    %rSumO = repmat(projmat_art(k,2*D:-1:D+1)',1,D);
    % %
    %cSumO = repmat(projmat_art(k,  1:  D) ,D,1); %image(cSumO);
    %rSumO = repmat(projmat_art(k,D+1:2*D)',1,D); %image(rSumO);
    proj_vec = projmat_art(k,:);
    cSumO = repmat(proj_vec(  1:  D) ,D,1);
    rSumO = repmat(proj_vec(D+1:2*D)',1,D);
    %DEBUG
    % plot(projmat_art(k,1:D));
    % plot(projmat_art(k,D+1:2*D));
    % %
    %guess
    imG = (cSumO+rSumO)/(2*D);
    im_rot = imG;
    %correction
    for kk = 1:n_iter
        cSumG = repmat(sum(im_rot,1),D,1); %image(cSumG);
        rSumG = repmat(sum(im_rot,2),1,D); %image(rSumG);
        im_rot = im_rot+((cSumO-cSumG)+(rSumO-rSumG))/(2*D); %image(im_rot);
    end
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
