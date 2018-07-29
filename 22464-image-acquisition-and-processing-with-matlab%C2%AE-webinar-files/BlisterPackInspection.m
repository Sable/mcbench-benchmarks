%% Setting up
close all
clear all
clc

%% Read in the Image

% UNCOMMENT when a camera is available
% obj = videoinput('winvideo');
% obj_src= get(obj,'Source');
% set(obj_src,'Brightness',128);
% set(obj_src,'saturation',200);
% RGB = getsnapshot(obj);

RGB = imread('Sample 01.jpg');

% A sample image processing function
I = rgb2gray(RGB);
Ie = edge(I);

figure

subplot(2,3,1)
imshow(RGB);
title('Original Image');

subplot(2,3,2)
imshow(Ie)
title('Edge Detection');


%% Perform K-means Clustering
cform = makecform('srgb2lab');
I_lab = applycform(RGB,cform);

ab = double(I_lab(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 2;
% repeat the clustering 5 times to avoid local minima
[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
    'Replicates',8);

% select cluster with least amount to find the pills
pixel_labels = reshape(cluster_idx,nrows,ncols);

if sum(pixel_labels(:)==1)>sum(pixel_labels(:)==2)
    clus_idx = 2;
else
    clus_idx = 1;
end

subplot(2,3,3);
imshow(pixel_labels,[]);
title('Image labeled by cluster index');

% Display segmented pills in color
segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nColors
    color = RGB;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

subplot(2,3,4);
imshow(segmented_images{clus_idx})
title('Objects in selected cluster');


%% Blob Detection and Region Properties
% We detect blobs and their region properties to find broken tablets
I_bw = pixel_labels==clus_idx;

I_bw_closed = imclose(I_bw,strel('disk',10));
I_bw_corrected = bwlabel(I_bw_closed).*I_bw;

subplot(2,3,5);
imshow(label2rgb(I_bw_corrected))
title('Indexed Objects');

% Gather statistics about the pills
sol = regionprops(I_bw_corrected,'solidity');
area = regionprops(I_bw_corrected,'area');

subplot(2,3,6)
imshow(RGB);
hold on;

cen = regionprops(I_bw_corrected,'centroid');
coords = reshape([cen(:).Centroid],2,max(I_bw_corrected(:)))';

% Display information onto the image
for i = 1:max(I_bw_corrected(:))
    text(coords(i,1),coords(i,2), sprintf('%2.2f',sol(i).Solidity) );
    % looking for area here to take care of pills that are off the side of
    % the image
    if area(i).Area/max([area.Area]) > 0.2
        if sol(i).Solidity > 0.8
            plot(coords(i,1),coords(i,2),'og','MarkerSize',12,'LineWidth',2);
        elseif sol(i).Solidity <= 0.8
            plot(coords(i,1),coords(i,2),'xr','MarkerSize',12,'LineWidth',2);
        end
    end
end
title('Pass/Fail Indicator');
