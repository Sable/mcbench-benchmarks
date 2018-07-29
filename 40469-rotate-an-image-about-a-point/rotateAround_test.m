% Test rotate around

%% Set test parameters
imageX = 300;
imageY = 200;
pointX = 30;
pointY = 50;
angle =  30;

%% Create test image - black dot on white field
image = ones(imageY, imageX);
image(pointY, pointX) = 0;

%% Rotate the image around the black dot
rotated = rotateAround(image, pointY, pointX, angle);

%% Plot the rotated image with the original dot position highlighted
imshow(rotated);
hold on
plot(pointX, pointY, 'or')