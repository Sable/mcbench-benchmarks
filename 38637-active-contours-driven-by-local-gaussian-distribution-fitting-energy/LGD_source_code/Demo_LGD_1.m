% This is a demo for segmentation using local gaussian distribution (LGD)
% fitting energy
%
% Reference: <Li Wang, Lei He, Arabinda Mishra, Chunming Li. 
% Active Contours Driven by Local Gaussian Distribution Fitting Energy.
% Signal Processing, 89(12), 2009,p. 2435-2447>
%
% Please DO NOT distribute this code to anybody.
% Copyright (c) by Li Wang
%
% Author:       Li Wang
% E-mail:       li_wang@med.unc.edu
% URL:          http://www.unc.edu/~liwa/
%
% 2010-01-02 PM



clc;clear all;close all;

Img=imread('1.bmp');
Img = double(Img(:,:,1));

NumIter = 300; %iterations
timestep=0.1; %time step
mu=0.1/timestep;% level set regularization term, please refer to "Chunming Li and et al. Level Set Evolution Without Re-initialization: A New Variational Formulation, CVPR 2005"
sigma = 3;%size of kernel
epsilon = 1;
c0 = 2; % the constant value 
lambda1=1.0;%outer weight, please refer to "Chunming Li and et al,  Minimization of Region-Scalable Fitting Energy for Image Segmentation, IEEE Trans. Image Processing, vol. 17 (10), pp. 1940-1949, 2008"
lambda2=1.0;%inner weight
%if lambda1>lambda2; tend to inflate
%if lambda1<lambda2; tend to deflate
nu = 0.001*255*255;%length term
alf = 30;%data term weight


figure,imagesc(uint8(Img),[0 255]),colormap(gray),axis off;axis equal
[Height Wide] = size(Img);
[xx yy] = meshgrid(1:Wide,1:Height);
phi = (sqrt(((xx - 65).^2 + (yy - 40).^2 )) - 20);
phi = sign(phi).*c0;


Ksigma=fspecial('gaussian',round(2*sigma)*2 + 1,sigma); %  kernel
ONE=ones(size(Img));
KONE = imfilter(ONE,Ksigma,'replicate');  
KI = imfilter(Img,Ksigma,'replicate');  
KI2 = imfilter(Img.^2,Ksigma,'replicate'); 


figure,imagesc(uint8(Img),[0 255]),colormap(gray),axis off;axis equal,
hold on,[c,h] = contour(phi,[0 0],'r','linewidth',1); hold off
pause(0.5)

tic
for iter = 1:NumIter
    phi =evolution_LGD(Img,phi,epsilon,Ksigma,KONE,KI,KI2,mu,nu,lambda1,lambda2,timestep,alf);

    if(mod(iter,25) == 0)
        figure(2),
        imagesc(uint8(Img),[0 255]),colormap(gray),axis off;axis equal,title(num2str(iter))
        hold on,[c,h] = contour(phi,[0 0],'r','linewidth',1); hold off
        pause(0.02);
    end

end
toc



