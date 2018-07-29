%TEST 02: Tomographic Reconstruction
clear
clc
fprintf('TEST 02: Tomographic Reconstruction.\nCompare two methods: FBP and ART\r');
im = imtest('phan',64);
[M,N] = size(im);
D = ceil(sqrt(M^2+N^2));
M_pad = ceil((D-M)/2)+1;
N_pad = ceil((D-N)/2)+1;
figure('name','Original Image')
imshow(im)
%Reconstruct from 10 angles
fprintf('reconstruct from 10 angles...\r')
angles = 0:18:179;
fprintf('FBP method\r')
[projmat,~] = tomoproj2d(im,angles);
im_rec1 = tomo_recon_fbp(projmat,angles);
im_rec1 = im_rec1(M_pad:D-M_pad,N_pad:D-N_pad);
im_rec1 = uint8(imscale(im_rec1));
figure('name','FBP')
imshow(im_rec1);
fprintf('ART method\niteration 1000\r')
im_rec2 = tomo_recon_myart_im(im,angles,1000);
figure('name','ART')
im_rec2 = uint8(imscale(im_rec2));
imshow(im_rec2)
%Reconstruct from 30 angles
fprintf('reconstruct from 30 angles...\r')
angles = 0:6:179;
fprintf('FBP method\r')
[projmat,~] = tomoproj2d(im,angles);
im_rec1 = tomo_recon_fbp(projmat,angles);
im_rec1 = im_rec1(M_pad:D-M_pad,N_pad:D-N_pad);
im_rec1 = uint8(imscale(im_rec1));
figure('name','FBP')
imshow(im_rec1);
fprintf('ART method\niteration 1000\r')
im_rec2 = tomo_recon_myart_im(im,angles,1000);
figure('name','ART')
im_rec2 = uint8(imscale(im_rec2));
imshow(im_rec2)
