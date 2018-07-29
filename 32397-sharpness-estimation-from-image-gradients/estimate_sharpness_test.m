
% by Tolga Birdal

% Sharpness estimation using gradients
% This is the most simple and basic measure of sharpness. Although many
% great other techniques exist, even this primitive estimation algorithm
% finds itself decent practical usage.
% The file reads an image and iteratively smooths it more and more to
% present how sharpness reduces.
% The method is tested against mean and unsharp (sharpen) filtering.
%
% Usage: Just execute this file. (Remember to have lena.jpg next to this
% file)
% All results will be printed to matlab console.
%
% Copyright (c) 2011, Tolga Birdal <http://www.tbirdal.me>

function []=estimate_sharpness_test()

close all;
I=imread('lena.jpg');
G=double(rgb2gray(I));

% measure the sharpness of original image
sharpness=estimate_sharpness(G);
disp(['Sharpness of original image: ' num2str(sharpness)]);

% iteratively smooth and measure sharpness
for i=3:2:11
    F=imfilter(G, fspecial('average',i), 'replicate');
    sharpness=estimate_sharpness(F);
    disp(['Sharpness after mean filtering: ' num2str(sharpness) '.  Kernel Size: ' num2str(i)]);
end

disp(' ');
% iteratively sharpen the image and measure sharpness
for i=1:-0.25:0
    F=imfilter(G, fspecial('unsharp',i), 'replicate');
    sharpness=estimate_sharpness(F);
    disp(['Sharpness after unsharp masking: ' num2str(sharpness) '.  Alpha: ' num2str(i)]);
end

end

% Estimate sharpness using the gradient magnitude.
% sum of all gradient norms / number of pixels give us the sharpness
% metric.
function [sharpness]=estimate_sharpness(G)

[Gx, Gy]=gradient(G);

S=sqrt(Gx.*Gx+Gy.*Gy);
sharpness=sum(sum(S))./(numel(Gx));

end
