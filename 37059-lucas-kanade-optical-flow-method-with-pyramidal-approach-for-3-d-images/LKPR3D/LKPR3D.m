function [ ux, uy, uz ] = LKPR3D( image1, image2, r, numlevels, iterations, sigma )
%This function estimates deformation between two subsequent 3-D images using
%Lucas-Kanade optical flow equation with pyramidal approach.
%
%   Description :
%
%   -image1, image2 : two subsequent images or frames.
%   -r : redius of neighbourhood, default value is 2.
%   -numlevels : the number of levels in pyramid, default value is 2.
%   -iterations : number of iterations in refinement, default value is 1.
%   -sigma : standard deviation of Gaussian function, default value is 0.5.
%
%   Reference:
%   Lucas, B. D., Kanade, T., 1981. An iterative image registration 
%   technique with an application to stereo vision. In: Proceedings of the 
%   7th international joint conference on Artificial intelligence - Volume 2.
%   Morgan Kaufmann Publishers Inc., San Francisco, CA, USA, pp. 674-679.
%
%   Author: Mohammad Mustafa
%   By courtesy of The University of Nottingham and Mirada Medical Limited,
%   Oxford, UK
%
%   Published under a Creative Commons Attribution-Non-Commercial-Share Alike
%   3.0 Unported Licence http://creativecommons.org/licenses/by-nc-sa/3.0/
%   
%   June 2012

% Default parameters
if nargin==5
    sigma=0.5;
elseif nargin==4
    iterations=1; sigma=0.5;
elseif nargin==3
    numlevels=2; iterations=1; sigma=0.5;
elseif nargin==2
    r=2; numlevels=2; iterations=1; sigma=0.5;
end

currentImage1=image1; currentImage2=image2; 

% s contains sizes of each pyramid levels
s=zeros(1,3,numlevels);
s(:,:,1)=(size(image1));

% Each of pyramid levels will have resized image 
pyrIm1=zeros(size(image1,1),size(image1,2),size(image1,3),numlevels); 
pyrIm2=pyrIm1;
pyrIm1(:,:,:,1)=currentImage1;
pyrIm2(:,:,:,1)=currentImage2;


% Building pyramid by downsampling
for i=2:numlevels
    currentImage1 = sampling3D(currentImage1,1); 
    currentImage2 = sampling3D(currentImage2,1);
    % Adjusting the size
    pyrIm1(1:size(currentImage1,1),1:size(currentImage1,2),...
            1:size(currentImage1,3),i)=currentImage1;
    pyrIm2(1:size(currentImage2,1),1:size(currentImage2,2),...
            1:size(currentImage2,3),i)=currentImage2;
    s(:,:,i)=size(currentImage1);
end

% Base operation
currentImage1=pyrIm1(1:s(1,1,numlevels),1:s(1,2,numlevels),...
                        1:s(1,3,numlevels),numlevels);
currentImage2=pyrIm2(1:s(1,1,numlevels),1:s(1,2,numlevels),...
                        1:s(1,3,numlevels),numlevels);
                   
[ux,uy,uz]=LKW3D(currentImage1,currentImage2,r,sigma);

% Refining flow vectors
if iterations>0
    for i=1:iterations
    [ux,uy,uz]=refinedLK3D(ux,uy,uz,currentImage1,currentImage2,r,sigma);
    end
end    

% Operations at higher levels of pyramids

for i=(numlevels-1):-1:1 
    % Size and magnitudes of flow vectors are upsampled
    temp=2 * sampling3D(ux,2); 
    uxInitial=temp(1:s(1,1,i),1:s(1,2,i),1:s(1,3,i));    
    temp=2 * sampling3D(uy,2);
    uyInitial=temp(1:s(1,1,i),1:s(1,2,i),1:s(1,3,i));
    temp=2 * sampling3D(uz,2); 
    uzInitial=temp(1:s(1,1,i),1:s(1,2,i),1:s(1,3,i));
    
    currentImage1=pyrIm1(1:s(1,1,i),1:s(1,2,i),1:s(1,3,i),i);
    currentImage2=pyrIm2(1:s(1,1,i),1:s(1,2,i),1:s(1,3,i),i);

    [ux,uy,uz]=refinedLK3D(uxInitial,uyInitial,uzInitial,...
                            currentImage1,currentImage2,r,sigma);
    if iterations>0   
        for j=1:iterations
            [ux,uy,uz]=refinedLK3D(ux,uy,uz,currentImage1,currentImage2,2,sigma);
        end
    end
end


end
