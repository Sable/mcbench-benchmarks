function test_rect_hor_img
%TEST_RECT_HOR_IMG Test Hor Rectangular Image with DRAGZOOM

im = imread('board.tif');

imh(:,:,1) = im(:,:,1)';
imh(:,:,2) = im(:,:,2)';
imh(:,:,3) = im(:,:,3)';

figure;
imshow(imh, 'InitialMagnification', 'fit');
% imagesc(imh);

dragzoom();
