%% Copyright 2011-2013 The MathWorks, Inc.                                 
% This is a simple demo to visualize SURF features of the video data. 
% 
% Original version created by Takuya Otani
% Senior Application Engineer, MathWorks, Japan
% 
clear all; close all; clc;

%% Load reference image, and compute surf features
ref_img = imread('MWqueen_crop_small.bmp');
ref_img_gray = rgb2gray(ref_img);
ref_pts = detectSURFFeatures(ref_img_gray);
[ref_features,  ref_validPts] = extractFeatures(ref_img_gray,  ref_pts);

figure; imshow(ref_img);
hold on; plot(ref_pts.selectStrongest(50));
%% Visual 25 SURF features
figure;
subplot(5,5,3); title('First 25 Features');
for i=1:25
    scale = ref_pts(i).Scale;
    image = imcrop(ref_img,[ref_pts(i).Location-10*scale 20*scale 20*scale]);
    subplot(5,5,i);
    imshow(image);
    hold on;
    rectangle('Position',[5*scale 5*scale 10*scale 10*scale],'Curvature',1,'EdgeColor','g');
end
%% Compare to video frame
image = imread('MWsample_full.png');
I = rgb2gray(image);

% Detect features
I_pts = detectSURFFeatures(I);
[I_features, I_validPts] = extractFeatures(I, I_pts);
figure;imshow(image);
hold on; plot(I_pts.selectStrongest(50));

%% Compare card image to video frame
index_pairs = matchFeatures(ref_features, I_features);

ref_matched_pts = ref_validPts(index_pairs(:,1)).Location;
I_matched_pts = I_validPts(index_pairs(:,2)).Location;

figure, showMatchedFeatures(image, ref_img, I_matched_pts, ref_matched_pts, 'montage');
title('Showing all matches');

%% Define Geometric Transformation Objects
gte = vision.GeometricTransformEstimator; 
gte.Method = 'Random Sample Consensus (RANSAC)';

[tform_matrix, inlierIdx] = step(gte, ref_matched_pts, I_matched_pts);

ref_inlier_pts = ref_matched_pts(inlierIdx,:);
I_inlier_pts = I_matched_pts(inlierIdx,:);

% Draw the lines to matched points
figure;showMatchedFeatures(image, ref_img, I_inlier_pts, ref_inlier_pts, 'montage');
title('Showing match only with Inliers');

%% Transform the corner points 
% This will show where the object is located in the image

tform = maketform('affine',double(tform_matrix));
[width, height,~] = size(ref_img);
corners = [0,0;height,0;height,width;0,width];
new_corners = tformfwd(tform, corners(:,1),corners(:,2));
figure;imshow(image);
patch(new_corners(:,1),new_corners(:,2),[0 1 0],'FaceAlpha',0.5);
