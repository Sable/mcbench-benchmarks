%% Character Recognition Example (I):Image Pre-processing

%% Manual Cropping 
img = imread('sample.bmp');
imshow(img)
imgGray = rgb2gray(img);
imgCrop = imcrop(imgGray);
imshow(imgCrop)

%% Resizing
imgLGE = imresize(imgCrop, 5, 'bicubic');
imshow(imgLGE)

%% Rotation
imgRTE = imrotate(imgLGE, 35);
imshow(imgRTE)

%% Binary Image
imgBW = im2bw(imgLGE, 0.90455);
imshow(imgBW)