function L = djs_bwlable(im)
%Effect: label the binary image 'im' via disjoint set data structure
%Inputs:
%  im: binary image
%Outputs:
%  L: the label image with 8-connection
%Author: Su dongcai at 2012/1/23
im = reshape(double(im(:)), size(im));
%the core rountine implementing 'bwlable' with 8-connection in 'cLable.h'
tic, L = vcBwlable(im); toc;
%Displaying:
figure, subplot(1, 2, 1), imshow(im, []), title('original binary image');
subplot(1, 2, 2), imshow(label2rgb(L+1)), title('labeled image');