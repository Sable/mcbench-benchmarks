%TEST 01: Compare Anisotropic Filter and Bilateral Filter.
clear
clc
n_it = 15;
tao = 0.1;
lambda = 30;
gn = 1;
fprintf('TEST 01: Compare Anisotropic Filter and Bilateral Filter.\r');
fprintf('Parameters:\n\nAnisoDiff:\niteration %d\ntao       %f\nlambda    %f\r',n_it,tao,lambda);
fprintf('Bilateral:\ninteration %d\nmask size  %dx%d\nlambda_s   AUTO\nlambda_r   AUTO\r',n_it,2*gn+1,2*gn+1);
load bone01;
im0 = rgb2gray(im0);
im1 = anisodiff(im0,n_it,tao,lambda,1);
im2 = bilateral_filter(im0,n_it,gn);
figure('name','Original Image')
imshow(uint8(im0));
figure('name','Anisotropic Filter')
imshow(uint8(im1));
figure('name','Bilateral Filter')
imshow(uint8(im2));
