% Author: John D'Errico
% Release: 1.0
% Release date: 9/19/06
% example usages of fuzzycolor

%% Testing single colors for a given color name match

% Is [1 0.1 0.1] a red?   (YES)
fuzzycolor([1 0.1 0.1],'red')

% Is [1 0.1 0.1] a blue?  (NO)
fuzzycolor([1 0.1 0.1],'blue')

%% Some colors are near the edge

% Is [1 0.3 0.3] a red?   (Yes, but perhaps only marginally so.)
fuzzycolor([1 0.3 0.3],'red')

%% Testing a single color for any match from the color name database

% What color is [1 1 .2]? (It should be a variant of yellow.)
[iscolor,colornames] = fuzzycolor([1 1 .2])

%% A set of random color patches

CP = sortrows(rand(10000,3));

figure
displaycolorpatches(CP)

%% Which patches were essentially red?

isc = fuzzycolor(CP,'red')>0.5;
figure
displaycolorpatches(CP(isc,:))

%% Which patches were essentially blue?

% Note that 'b' is not an acceptable abbreviation for 'blue', as there
% are also other colornames that would match 'b'.
isc = fuzzycolor(CP,'blue')>0.5;
figure
displaycolorpatches(CP(isc,:))

%% Which patches were essentially green?

% Note that 'g' is an acceptable abbreviation for 'green'
isc = fuzzycolor(CP,'g')>0.5;
figure
displaycolorpatches(CP(isc,:))

%% Which patches were essentially a flesh tone?

isc = fuzzycolor(CP,'flesh')>0.5;
figure
displaycolorpatches(CP(isc,:))

%% An actual jpg image
imrgb = imread('monet_adresse.jpg');

figure
image(imrgb)

%% Which pixels were green? Turn ALL the other pixels to white.
indg = find(fuzzycolor(double(imrgb)/255,'green')<0.5);
n = size(imrgb,1)*size(imrgb,2);

img = imrgb;
img([indg;indg+n;indg+2*n]) = 255;

figure
image(img)
