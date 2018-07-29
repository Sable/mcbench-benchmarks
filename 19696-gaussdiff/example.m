% This simple example shows taking gaussian derivatives on an image
% using the function gfilter.

% set scale, play with this :)
sigma = 2;

% load image and normalize
im  = imread('peppers.png');
im = double( rgb2gray( im ) )/255;

% create figure
figure(1); clf;

% now just calculate and put in subplots...

tmp = gfilter(im,sigma);
subplot(331);
imshow(tmp);
xlabel('Only smoothed');

tmp = gfilter(im,sigma,[0 1]);
subplot(332);
imshow(tmp,[]);
xlabel('Lx');

tmp = gfilter(im,sigma,[0 2]);
subplot(333);
imshow(tmp,[]);
xlabel('Lxx');


tmp = gfilter(im,sigma,[1 0]);
subplot(334);
imshow(tmp,[]);
xlabel('Ly');

tmp = gfilter(im,sigma,[1 1]);
subplot(335);
imshow(tmp,[]);
xlabel('Lxy');

tmp = gfilter(im,sigma,[1 2]);
subplot(336);
imshow(tmp,[]);
xlabel('Lxxy');


tmp = gfilter(im,sigma,[2 0]);
subplot(337);
imshow(tmp,[]);
xlabel('Lyy');

tmp = gfilter(im,sigma,[2 1]);
subplot(338);
imshow(tmp,[]);
xlabel('Lxyy');

tmp = gfilter(im,sigma,[2 2]);
subplot(339);
imshow(tmp,[]);
xlabel('Lxxyy');



