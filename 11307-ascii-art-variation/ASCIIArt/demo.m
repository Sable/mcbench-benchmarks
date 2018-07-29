%% ASCII Art
%  The ASCII art is an interesting art of representing images using
% characters. In the past a great number of powerful libs and tools are
% develped, the most famous is aalib that allow to paint in real time a
% stream of images (a video) containing only ASCII characters (on a TTY).
% So for example the using the mplayer under Linux it is possible to see a
% DVD film completely in ASCII art, or to play Quake with it's aalib version
% (tty-quake). Here a simple ASCII art converter function is given using
% multiple palettes depending on the gradient of the image, something
% different with respecto to the other AA tools.

%% Reading an image
%  Reading and preparing an image for the conversion: an image must be
% gayscale to be used with gabAscii.

% Getting a standard image:
img = imread('peppers.png');

% Converting to grayscale:
img = rgb2gray(img);

%% Generating the ASCII-Art version of the image
%  Here the ASCII-Art version of the image is generated using the default
% parameters, in this tool the size of the axels and the palettes can be
% defined as parameters.

% Generation of the output:
asciiImg = gabAscii(img),
