% Jason Joseph Rebello
% Carnegie Mellon University (Jan 2012 - May 2013) 
% MS in Electrical & Computer Engineering
% K Means Algorithm with the application to image compression

% This program uses the K means clustering algorithm to group the pixels  
% in an image in order to provide image compression.

clear all;
clc;
close all;

fprintf('K means clustering algorithm used for image compression\n\n');
t = cputime;

%% Read the image
fprintf('Reading image');
I = imread('bird_small.png');
%imshow(I);
I = (double(I))/255;
fprintf('...done\n\n');

%% Declare and Initialize Variabels
fprintf('Initializing variables');
K = 16; % number of clusters
imgSize = size(I); % get size of image
iterCentroids = 10; % number of times K means runs to find the best centroid
iterKMeans = 10; % number of times K means runs with different initial centroids
fprintf('...done\n\n');

%% Get input
fprintf('Formatting input');
X = reshape(I, imgSize(1) * imgSize(2), 3); % resize into (total pixel x features)
fprintf('...done\n\n');

%% Run K Means
for i=1:iterKMeans
    
    fprintf(' ********* Running K means iteration %d ***********\n\n',i);
    [centroids cost idx] = runKMeans(X, K, iterCentroids);
    fprintf('Cost after %d iteration : %f\n\n',i,cost);
    
    if i==1
        bestCentroids = centroids;
        bestCost = cost;
        bestidx = idx;
    elseif (i>1 && cost<bestCost) % stores the best clustering
        bestCentroids = centroids;
        bestCost = cost;
        bestidx = idx;   
    end
    fprintf('Best cost : %f\n\n',bestCost);  

XCompressed = centroids(idx,:);

% Reshape the recovered image into proper dimensions
XCompressed = reshape(XCompressed, imgSize(1), imgSize(2), 3);
imshow(XCompressed); % display final compressed image for each iteration
pause(1);

end

%% Display original and best compressed image
XCompressed = bestCentroids(bestidx,:);

% Reshape the recovered image into proper dimensions
XCompressed = reshape(XCompressed, imgSize(1), imgSize(2), 3);
displayImage(I, XCompressed, K);

fprintf('Program executed in %f seconds or %f minutes\n\n', cputime-t, (cputime-t)/60);
