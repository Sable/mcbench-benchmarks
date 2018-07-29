%TEST 07: Simple v.s. Area (two methods of building weight matrix)
clear
clc
fprintf('TEST 07: Simple v.s. Area (two methods of building weight matrix)\r');
im = imtest('s4',156);
figure('name','Original Image: Phantom')
imshow(im)
siz = size(im);
angles = 0:3:179;
[W1,p1,~,~] = buildWeightMatrixSimple(im,angles);
[W2,p2,~,~] = buildWeightMatrixArea(im,angles);
%Simple
fprintf('Reconstruct from simple-W:\r')
im_rec1 = tomo_recon_lsqr(W1, p1, siz, 1e-6, 1000);
im_rec1 = uint8(imscale(im_rec1));
figure('name','Simple')
imshow(im_rec1);
%Area
fprintf('Reconstruct from area-W:\r')
im_rec2 = tomo_recon_lsqr(W2, p2, siz, 1e-6, 1000);
im_rec2 = uint8(imscale(im_rec2));
figure('name','Area')
imshow(im_rec2);
