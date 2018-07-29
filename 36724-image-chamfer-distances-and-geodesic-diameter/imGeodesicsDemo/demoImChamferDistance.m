function varargout = demoImChamferDistance(varargin)
%DEMOIMCHAMFERDISTANCE computes distance function inside a complex particle
%
%   output = demoImChamferDistance(input)
%
%   Example
%   demoImChamferDistance
%
%   See also
%
%
% ------
% Author: David Legland
% e-mail: david.legland@grignon.inra.fr
% Created: 2010-08-02,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2010 INRA - Cepia Software Platform.

%% Read image a create marker

% read image
img = imread('circles.png');

% create marker
marker = false(size(img));
marker(80, 80) = 1;

% show image
imshow(imoverlay(img, imdilate(marker, ones(3, 3))));


%% compute using quasi-enclidean weights

dist = imChamferDistance(img, marker);
figure; 
imshow(dist, []);
colormap(jet); 
title('Quasi-euclidean distance');

%% compute using integer weights, giving integer results

dist34 = imChamferDistance(img, marker, int16([3 4]));
figure; 
imshow(double(dist34)/3, [0 max(dist34(img))/3]);
colormap(jet); 
title('Borgefors 3-4 weights');
 