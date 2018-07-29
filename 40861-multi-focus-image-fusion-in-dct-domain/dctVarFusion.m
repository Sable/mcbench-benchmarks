function [fusedDctVarCv, fusedDctVar] = dctVarFusion(im1, im2)

% DCTVARFUSION is the simulation of following multi-focus image fusion methods:
% 
% (1) DCT+Variance+CV
% (2) DCT+Variance
% 
% proposed in:
% 
% M.B.A. Haghighat, A. Aghagolzadeh, H. Seyedarabi:
% "Multi-Focus Image Fusion for Visual Sensor Networks in DCT Domain,"
% Computers and Electrical Engineering, vol. 37, no. 5, pp. 789-797, Sep. 2011
% http://dx.doi.org/10.1016/j.compeleceng.2011.04.016
% 
% 
% Inputs:
%       im1	:	First source image 
%       im2	:	Second source image
%               
% Outputs:
%       fusedDctVarCv	:	Fused image as the result of "DCT+Variance+CV" method
%       fusedDctVar		:	Fused image as the result of "DCT+Variance" method
% 
% 
% Sample use:
% im1 = imread('pepsi1.tif');
% im2 = imread('pepsi2.tif');
% [fusedDctVarCv, fusedDctVar] = dctVarFusion(im1, im2);
% 
% 
% (C)	Mohammad Haghighat, University of Miami
%       haghighat@ieee.org


if nargin ~= 2	% check correct number of arguments
    error('There should be two input images!')
end

if size(im1,3) == 3     % Check if the images are grayscale
    im1 = rgb2gray(im1);
end
if size(im2,3) == 3
    im2 = rgb2gray(im2);
end

if size(im1) ~= size(im2)	% Check if the input images are of the same size
    error('Size of the source images must be the same!')
end


% Get input image size
[m,n] = size(im1);
fusedDctVar = zeros(m,n);
fusedDctVarCv = zeros(m,n);
cvMap = zeros(floor(m/8),floor(n/8));	% Consistency verification index map

% Level shifting
im1 = double(im1)-128;
im2 = double(im2)-128;

% Divide source images into 8*8 blocks and perform the fusion
for i = 1:floor(m/8)
    for j = 1:floor(n/8)
        
        im1Sub = im1(8*i-7:8*i,8*j-7:8*j);
        im2Sub = im2(8*i-7:8*i,8*j-7:8*j);
        
        % Compute the 2-D DCT of 8*8 blocks
        im1SubDct = dct2(im1Sub);
        im2SubDct = dct2(im2Sub);
        
        % Calculate normalized transform coefficients
        im1Norm = im1SubDct ./ 8;
        im2Norm = im2SubDct ./ 8;
        
        % Mean value of 8*8 block of images (Measure for surrounding lumminance)
        im1Mean = im1Norm(1,1);
        im2Mean = im2Norm(1,1);
        
        % Variance of 8*8 block of images
        im1Var = sum(sum(im1Norm.^2)) - im1Mean.^2;
        im2Var = sum(sum(im2Norm.^2)) - im2Mean.^2;
        
        % Fusion
        if im1Var > im2Var
            dctVarSub = im1SubDct;
            cvMap(i,j) = -1;	% Consistency verification index
        else
            dctVarSub = im2SubDct;
            cvMap(i,j) = +1;    % Consistency verification index
        end
        
        % Compute the 2-D inverse DCT of 8*8 blocks and construct fused image
        fusedDctVar(8*i-7:8*i,8*j-7:8*j) = idct2(dctVarSub);	% DCT+Variance method
        
    end
end

% Concistency verification using a Majority Filter
fi = ones(7)/49;	% Filter kernel 7*7
cvMapFiltered = imfilter(cvMap, fi, 'symmetric');	% Filtered index map
cvMapFiltered = imfilter(cvMapFiltered, fi, 'symmetric');


for i = 1:m/8
    for j = 1:n/8
        % DCT+Variance+CV method
        if cvMapFiltered(i,j) <= 0
            fusedDctVarCv(8*i-7:8*i,8*j-7:8*j) = im1(8*i-7:8*i,8*j-7:8*j);
        else
            fusedDctVarCv(8*i-7:8*i,8*j-7:8*j) = im2(8*i-7:8*i,8*j-7:8*j);
        end
        
    end
end


% Inverse level shifting: 
im1 = uint8(double(im1)+128);
im2 = uint8(double(im2)+128);
fusedDctVar = uint8(double(fusedDctVar)+128);
fusedDctVarCv = uint8(double(fusedDctVarCv)+128);

% Show table
subplot(2,2,1), imshow(im1), title('Source image 1');
subplot(2,2,2), imshow(im2), title('Source image 2');
subplot(2,2,3), imshow(fusedDctVar), title('"DCT+Variance"  fusion result');
subplot(2,2,4), imshow(fusedDctVarCv), title('"DCT+Variance+CV"  fusion result');
