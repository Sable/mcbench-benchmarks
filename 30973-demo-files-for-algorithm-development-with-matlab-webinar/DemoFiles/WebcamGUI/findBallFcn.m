function centroid = findBallFcn(greenBall1, thresh, imageType, axH)

% Copyright 2011 The MathWorks, Inc.

error(nargchk(3, 4, nargin, 'struct'));

if isempty(greenBall1)
    return;
end
if ischar(greenBall1)
    greenBall1 = imread(greenBall1);
end

%% Find Green Object
% This script reads in an image file and then attempts to find a green
% object in the image. It is designed to find one green ball and highlight
% that ball on the original image

%% Extract each color
% Next we using indexing to extract three 2D matrices from the 3D image
% data corresponding to the red, green, and blue components of the image.

r = greenBall1(:, :, 1);
g = greenBall1(:, :, 2);
b = greenBall1(:, :, 3);

%% Calculate Green
% Then we perform an arithmetic operation on the matrices as a whole to try
% to create one matrix that represents an intensity of green.

justGreen = g - r/2 - b/2;

%% Threshold the image
% Now we can set a threshold to separate the parts of the image that we
% consider to be green from the rest.

if nargin == 4
    bw = justGreen > thresh;
else
    bw = justGreen > 80;
end

%% Remove small groups
% We can use special functions provided by the Image Processing toolbox to
% quickly perform common image processing tasks. Here we are using
% BWAREAOPEN to remove groups of pixels less than 30.

ball1 = bwareaopen(bw, 30);

%% Find center
% Now we are using REGIONPROPS to extract the centroid of the group of
% pixels representing the ball.

s  = regionprops(ball1, {'centroid','area'});
if isempty(s)
    centroid = [];
else
    [maxArea, id] = max([s.Area]); %#ok<ASGLU>
    centroid = s(id).Centroid;
end
switch imageType
   case 'video'
      imshow(greenBall1, 'Parent', axH);
      if ~isempty(centroid)
         line(centroid(1), centroid(2), 'Parent', axH, 'Color', 'w', 'Marker', 'p', 'MarkerSize', 20, 'MarkerFaceColor', 'r')
      end
   case 'bw'
      imshow(ball1, 'Parent', axH);
end
