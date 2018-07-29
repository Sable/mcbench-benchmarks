%TEST 04: Algebraic Reconstruction Techniques
clear
clc
fprintf('TEST 04: Algebraic Reconstruction Techniques\rCompare ART and SART\r');
angles = 0:6:179;
%Phantom
im = imtest('s4',64);
siz = size(im);
figure('name','Original Image: Phantom')
imshow(im)
[W, p, ~, ~] = buildWeightMatrix(im,angles);
%Iteration 100
fprintf('ART method\niteration 100:\r')
im_rec1 = tomo_recon_myart(W,p,siz,100);
im_rec1 = uint8(imscale(im_rec1));
figure('name','ART')
imshow(im_rec1);
fprintf('SART method\niteration 100:\r')
im_rec2 = tomo_recon_sart(W,p,siz,100);
im_rec2 = uint8(imscale(im_rec2));
figure('name','SART')
imshow(im_rec2);
%Iteration 1000
fprintf('ART method\niteration 1000:\r')
im_rec1 = tomo_recon_myart(W,p,siz,1000);
im_rec1 = uint8(imscale(im_rec1));
figure('name','ART')
imshow(im_rec1);
fprintf('SART method\niteration 1000:\r')
%Code efficiency is too low!
%im_rec2 = tomo_recon_mysart(W,p,siz,1000);
%figure('name','ART')
%imshow(im_rec2);
