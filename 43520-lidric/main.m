% Written by Sebastian Zambanini                                          
% web   : http://www.caa.tuwien.ac.at/cvl/people/zamba/                                     
% email : zamba@caa.tuwien.ac.at  
% Code is based on paper "A Local Image Descriptor Robust to Illumination
% Changes", SCIA 2013
% Version: 1.02

%this script is just an example how to use the code

%load image
img = im2double(rgb2gray(imread('car.png')));
%create Gabor Filter Bank
GFB = GaborFilterBank(size(img));

%create Feature Map
F = FeatureMap(img,GFB);

%extract LIDRICs at specified keypoint positions and scales
X = 200:20:600;
[X,Y] = meshgrid([250:5:300],[250:5:300]);
pos = [X(:)';Y(:)'];
D = LIDRIC(pos,12*ones(1,size(pos,2)),F);
