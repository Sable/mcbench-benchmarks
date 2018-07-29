%% Copyright 2011-2012 The MathWorks, Inc.
%% Set up scenario 
% Step 1: Read Image
original = imread('cameraman.tif');
figure; imshow(original); title 'Original image';

%% Step 2: Resize and Rotate the Image
scale = 0.7;
J = imresize(original, scale); % Scale Image
theta = 30;
distorted = imrotate(J,theta); % Rotate Image
figure;subplot(1,2,1); imshow(J); title 'Scaled image'
subplot(1,2,2); imshow(distorted); title 'Scaled and rotated image';

%% Step 3: Use SURF to Find Matching Features
% Show Surf Features on Distorted Image
ptsOriginal  = detectSURFFeatures(original);
ptsDistorted = detectSURFFeatures(distorted);

%% Visualize SURF features
figure; pts = ptsDistorted.selectStrongest(10);
for i=1:10
    scale = pts(i).Scale;
    image = imcrop(distorted,[pts(i).Location-10*scale 20*scale 20*scale]);
    subplot(2,5,i);
    imshow(image);
    hold on;
    rectangle('Position',[5*scale 5*scale 10*scale 10*scale],'Curvature',[1],'EdgeColor','g');
end

figure;imshow(distorted); hold on;
plot(ptsDistorted.selectStrongest(40)); 

%% Extract SURF features from both images. 
[featuresOrig   validPtsOrig]  = extractFeatures(original,  ptsOriginal);
[featuresDist   validPtsDist]  = extractFeatures(distorted, ptsDistorted);

%% Match features by using their descriptors and show results
index_pairs = matchFeatures(featuresOrig, featuresDist);

% Retrieve locations of corresponding points for each image.
matchedOriginal  = validPtsOrig(index_pairs(:,1)).Location;
matchedDistorted = validPtsDist(index_pairs(:,2)).Location;

% Show putative point matches.
h = cvexShowMatches(original,distorted,matchedOriginal,matchedDistorted,'original','distorted');
set(h,'Name','Putatively matched points (including outliers)','NumberTitle','off');

%% Step 4: Estimate Transformation
% Find a transformation matrix using RANSAC algorithm 
gte = vision.GeometricTransformEstimator;
gte.Transform = 'Nonreflective similarity';
gte.NumRandomSamplingsMethod = 'Desired confidence';
gte.MaximumRandomSamples = 1;
gte.DesiredConfidence = 99.8;
%% Show what happens in each iteration of RANSAC
figure;
for i = 1:10
    [tform_matrix inlierIdx] = step(gte,matchedDistorted,...
        matchedOriginal);
    imshow(original); hold on;
    pts = [matchedDistorted ones(size(matchedDistorted,1),1)] * tform_matrix;
    plot(matchedOriginal(:,1),matchedOriginal(:,2),'oy');
    plot(pts(:,1),pts(:,2),'+r');
    hold off; drawnow; pause;
end
close (gcf);
 %%
release(gte);
gte.MaximumRandomSamples = 1000;

% Compute the transformation from the distorted to the original image.
[tform_matrix inlierIdx] = step(gte, matchedDistorted, ...
    matchedOriginal);

% Display matching point pairs used to compute the transformation matrix.
h1 = cvexShowMatches(original,distorted,matchedOriginal(inlierIdx,:),...
    matchedDistorted(inlierIdx,:),'ptsOriginal','ptsDistorted');
set(h1,'Name','Matching points (inliers only)','NumberTitle','off');

%% Step 5: Compute Scale and Angle
tform_matrix = cat(2,tform_matrix,[0 0 1]'); % pad the matrix
tinv  = inv(tform_matrix);

ss = tinv(2,1);
sc = tinv(1,1);
scale_recovered = sqrt(ss*ss + sc*sc)
rotation_recovered = atan2(ss,sc)*180/pi

%% Step 6: Recover the Original Image (by transforming the distorted image)

agt = vision.GeometricTransformer;
agt.OutputImagePositionSource = 'Property';
%  Use the size of the original image to set the output size.
agt.OutputImagePosition = [1 1 size(original)];

recovered = step(agt, im2single(distorted), tform_matrix);
% Visualize Images for Comparison
figure;
subplot(1,2,1); imshow(original); title('original')
subplot(1,2,2); imshow(recovered); title('recovered')


