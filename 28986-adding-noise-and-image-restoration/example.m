% Author Deepak.
% Just provide the path of the image to add the noise or to restore the
% image.
clc;
f = imread('Place the path of your image file');
figure
imshow(f),title('Original Image')
[M N] = size(f);
% Any type of noise can b added to the image provided. Just see the
% imnoise2 file to see the various noise effects. Here an example is shown
% where we are adding the pepper noise to the image.
r = imnoise2('salt & pepper',M,N,0,0.1);
figure
imshow(r),title('Noise to be added');
c = find(r == 1);
gp = f;
gp(c) = 255;
figure
imshow(gp),title('Image after adding the Noise');
% The image distorted by adding the noise can be restored by using the
% function imrest. Here an example is shown by using contraharmonic filter.
% you can use various type of other filter to restore the image. For more
% detail just see the funcion imrest.
fp = imrest(gp,'chmean',3,3,-5.5);
figure
imshow(fp),title('Image after restoration.')
