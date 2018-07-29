% colony_count.m demo script
% Runs colony_count on example image and displays segmentation results.

% Load image.
I = imread('plate_example.jpg');

% Call function.
% Count is number of colonies, markers is the colony markers and mask is
% the colony segmentation. Count == # of components in markers.

% Optional parameter, this is the default.
% Should encompass internal radius of Petri dish.
radii = 115:1:130;

[count,markers,mask] = colony_count(I,radii);

disp([num2str(count) ' colonies detected.']);

% Overlay image with markers and mask.
J = rgb2gray(I);
R = J; G = J; B = J;
R(mask) = 255; R(markers) = 0;
G(mask) = 0; G(markers) = 255;
B(mask) = 0; B(markers) = 0;
RGB = cat(3,R,G,B);
figure();imshow(RGB);

% Overlay image with just markers.
R = J; G = J; B = J;
R(markers) = 0;
G(markers) = 255;
B(markers) = 0;
RGB = cat(3,R,G,B);
figure();imshow(RGB);