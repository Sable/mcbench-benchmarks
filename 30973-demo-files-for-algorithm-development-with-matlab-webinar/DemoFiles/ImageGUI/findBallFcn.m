function findBallFcn(greenBall1)

%% Find Green Object
% This script reads in an image file and then attempts to find a green
% object in the image. It is designed to find one green ball and highlight
% that ball on the original image

% Copyright 2011 The MathWorks, Inc.

%% Read in Image
% First we read the specified image from the file and bring it into MATLAB
% as a variable. We also display the image to ensure it is correct.

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

bw = justGreen > 80;

%% Remove small groups
% We can use special functions provided by the Image Processing toolbox to
% quickly perform common image processing tasks. Here we are using
% BWAREAOPEN to remove groups of pixels less than 30.
ball1 = bwareaopen(bw, 30);

%% Find center
% Now we are using REGIONPROPS to extract the centroid of the group of
% pixels representing the ball.
imshow(greenBall1);
s  = regionprops(ball1, {'centroid','area'});
if isempty(s)
  title('No ball found!');
else
  [~, id] = max([s.Area]);
  hold on, plot(s(id).Centroid(1),s(id).Centroid(2),'wp','MarkerSize',20,'MarkerFaceColor','r'), hold off
  title(['Center location is (',num2str(s(id).Centroid(1),4),', ',num2str(s(id).Centroid(2),4),')'])
end
