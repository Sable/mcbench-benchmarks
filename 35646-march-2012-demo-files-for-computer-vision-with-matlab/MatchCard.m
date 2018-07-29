%% Copyright 2011-2012 The MathWorks, Inc.                                 
% This is a simple demo to visualize SURF features of the video data. 
% 
% Original version created by Takuya Otani
% Senior Application Engineer, MathWorks, Japan
% 
%% Load reference image, and compute surf features
x_offset = 640;
y_offset = 140;
ref_img = imread('MWqueen_crop_small.bmp');
ref_img_gray = rgb2gray(ref_img);
ref_img_pad = padarray(ref_img, [y_offset 0], 'pre');
ref_pts = detectSURFFeatures(ref_img_gray);
[ref_features  ref_validPts] = extractFeatures(ref_img_gray,  ref_pts);

figure; imshow(ref_img);
hold on; h1= plot(ref_pts.selectStrongest(50));

%% Compare to video frame
image = imread('MWsample_full.png');
I = rgb2gray(image);

% Detect features
I_pts = detectSURFFeatures(I);
[I_features I_validPts] = extractFeatures(I, I_pts);
figure;imshow(image);
hold on; plot(I_pts.selectStrongest(50));

%% Compare card image to video frame
index_pairs = matchFeatures(ref_features, I_features);

ref_matched_pts = ref_validPts(index_pairs(:,1)).Location;
I_matched_pts = I_validPts(index_pairs(:,2)).Location;

% Draw the lines
ref_offset_matched_pts(:,1) = ref_matched_pts(:,1) + x_offset;
ref_offset_matched_pts(:,2) = ref_matched_pts(:,2) + y_offset;
Pts_match = [ref_offset_matched_pts I_matched_pts ];
I_cat = cat(2, image, ref_img_pad);

hshapeins = vision.ShapeInserter('Shape','Lines', 'BorderColor','Custom',...
                    'CustomBorderColor',[255 0 0]);

Iout = step(hshapeins, I_cat, int32(Pts_match));
figure; imshow(Iout);


%% Define Geometric Transformation Objects
gte = vision.GeometricTransformEstimator; 
gte.Method = 'Random Sample Consensus (RANSAC)';
gte.Transform = 'Nonreflective similarity';
gte.NumRandomSamplingsMethod = 'Desired confidence';
gte.MaximumRandomSamples = 5000;
gte.DesiredConfidence = 99.8;

[tform_matrix inlierIdx] = step(gte, ref_matched_pts, I_matched_pts);

ref_inlier_pts = ref_matched_pts(inlierIdx,:);
I_inlier_pts = I_matched_pts(inlierIdx,:);

% Draw the lines
ref_offset_inlier_points(:,1) = ref_inlier_pts(:,1) + x_offset;
ref_offset_inlier_points(:,2) = ref_inlier_pts(:,2) + y_offset;
Pts_match = [ref_offset_inlier_points I_inlier_pts];
I_cat = cat(2, image, ref_img_pad);

Iout = step(hshapeins, I_cat, int32(Pts_match));
figure; imshow(Iout);

%%
corners = [0,0;240,0;240,320;0,320];
found_corners = (corners*tform_matrix(1:2,1:2)+repmat(tform_matrix(3,1:2),4,1));
shapePoly = vision.ShapeInserter('Shape','Polygons','Fill',true);
Iout2 = step(shapePoly,Iout,int32(reshape(found_corners',8,1)));
figure;imshow(Iout2);