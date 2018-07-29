function [ux,uy,uz]=LKW3D( image1, image2, r, sigma )
%This function estimates deformation of two subsequent 3-D images using
%Lucas-Kanade optical flow equation with weighted window approach.
%
%   Description :
%
%   -image1, image2 :   two subsequent images or frames
%   -r : radius of the neighbourhood, default value is 2. 
%   -sigma : standard deviation of Gaussian function, default value is 0.5.
%   -ww : wighted window used in least square equation; it gives more
%         weight to the central pixel.
%
%   Reference :
%   Lucas, B. D., Kanade, T., 1981. An iterative image registration 
%   technique with an application to stereo vision. In: Proceedings of the 
%   7th international joint conference on Artificial intelligence - Volume 2.
%   Morgan Kaufmann Publishers Inc., San Francisco, CA, USA, pp. 674-679.
%
%   Author : Mohammad Mustafa
%   By courtesy of The University of Nottingham and Mirada Medical Limited,
%   Oxford, UK
%
%   Published under a Creative Commons Attribution-Non-Commercial-Share Alike
%   3.0 Unported Licence http://creativecommons.org/licenses/by-nc-sa/3.0/
%   
%   June 2012

% Default parameters
if nargin<3
    r=2; sigma=0.5;
elseif nargin==3
    sigma=0.5;
end

[h,w,d]=size(image1); 
image1=im2double(image1);
image2=im2double(image2);

% Initializing flow vectors 
ux=zeros(size(image1)); uy=ux; uz=ux;

% Gaussian wighted window to be used in least square equation
ww=gaussianKernel3D(r,sigma);

[Ix,Iy,Iz,It]=imageDerivatives3D(image1,image2);

for i=(r+1):(h-r)
    for j=(r+1):(w-r)
        for k=(r+1):(d-r)
        
        blockofIx=Ix(i-r:i+r,j-r:j+r,k-r:k+r);
        blockofIy=Iy(i-r:i+r,j-r:j+r,k-r:k+r);
        blockofIz=Iz(i-r:i+r,j-r:j+r,k-r:k+r);
        blockofIt=It(i-r:i+r,j-r:j+r,k-r:k+r);
        
        A=zeros(3,3);
        B=zeros(3,1);
        
        A(1,1)=sum(sum(sum( (blockofIx.^2).*ww )));
        A(1,2)=sum(sum(sum( (blockofIx.*blockofIy).*ww )));
        A(1,3)=sum(sum(sum( (blockofIx.*blockofIz).*ww )));
        
        A(2,1)=sum(sum(sum( (blockofIy.*blockofIx).*ww )));
        A(2,2)=sum(sum(sum( (blockofIy.^2).*ww )));
        A(2,3)=sum(sum(sum( (blockofIy.*blockofIz).*ww )));

        A(3,1)=sum(sum(sum( (blockofIz.*blockofIx).*ww )));
        A(3,2)=sum(sum(sum( (blockofIz.*blockofIy).*ww )));
        A(3,3)=sum(sum(sum( (blockofIz.^2).*ww )));
       
        B(1,1)=sum(sum(sum( (blockofIx.*blockofIt).*ww )));
        B(2,1)=sum(sum(sum( (blockofIy.*blockofIt).*ww )));
        B(3,1)=sum(sum(sum( (blockofIz.*blockofIt).*ww )));
        
        invofA=pinv(A);

        V=invofA*(-B);
        ux(i,j,k)=V(1,1);
        uy(i,j,k)=V(2,1);
        uz(i,j,k)=V(3,1);
        end
    end
end

end

