%original image
x = imread('rice.png');
imshow(x)
title('Raw Image')

%color map
figure
imshow(x)
colormap jet
title('Jet color map')

%background estimation (non uniform illumination)
bg = imopen(x,strel('disk',10));
figure
imshow(bg)
colormap jet
title Background

%background removal (flatten background level)
y = imsubtract(x,bg);
figure
imshow(y)
title Flattened

%segment grains from background
bw = im2bw(y,graythresh(y)); 
figure
imshow(bw)
title GrayThreshed

%label connected regions
L = bwlabel(bw);
figure
imshow(L,[])
colormap jet
pixval
title('Connected Regions')

%feature extraction - size distribution (area, pixels)
stats = regionprops(L);
A = [stats.Area];
figure
hist(A)
xlabel('Area (pixels)')
ylabel Popularity
title('Size Distribution')

%statistical measurements
mean(A)
std(A)
median(A)

% Copyright 2004-2010 RBemis The MathWorks, Inc. 
