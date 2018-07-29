function test_rect_ver_img
%TEST_RECT_VER_IMG Test Vertical Rectangular Image with DRAGZOOM

im = imread('board.tif');

figure;
imshow(im, 'InitialMagnification', 'fit');
% imagesc(im);

dragzoom();
