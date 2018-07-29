function test_img
%TEST_IMG Test Image with DRAGZOOM

im = imread('cameraman.tif'); % Load image from matlab search path

figure;
imshow(im, [], 'InitialMagnification', 'fit');

dragzoom();
