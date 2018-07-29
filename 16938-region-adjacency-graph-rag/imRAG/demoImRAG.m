function demoImRAG(varargin)
%Demo program for imRAG: apply on SKIZ computed on coins image
%   
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-01-22,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.


%% Read input image

img = imread('coins.png');

% make binary, and remove noise
bin = imopen(img > 80, ones(3, 3));
imshow(bin);


%% Compute Skeleton by Influence Zone (SKIZ)

% distance function
dist = bwdist(bin);
imshow(dist, []); title('distance function');

% compute watershed
distf = imfilter(dist, ones(3, 3)/9, inf);
wat = watershed(distf, 4);

% superposition of watershed on original image
ovr = imOverlay(img, imdilate(wat==0, ones(3, 3)));

% display result
figure;
imshow(ovr);
title('watershed');


%% Region adjacency graph

% Compute RAG
[n e] = imRAG(wat);

% diplay RAG with surimpression
hold on;
for i = 1:size(e, 1)
    plot(n(e(i,:), 1), n(e(i,:), 2), 'linewidth', 2, 'color', 'g');
end
plot(n(:,1), n(:,2), 'bo');
