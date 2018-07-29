%% test. 2-D image (gray scale)
img1 = imread('pout.tif'); % test image on path of Image Processing Toolbox
figure;imshow(img1);
img2 = mx_resize(img1);
figure;imshow(img2);
%% test. 3-D image (color image)
img3 = imread('greens.jpg'); % test image on path of Image Processing Toolbox
figure;imshow(img3);
img4 = mx_resize(img3);
figure;imshow(img4);