function [ux,uy,uz]=LK3D( image1, image2, r )
%This function estimates deformations between two subsequent 3-D images
%using Lucas-Kanade optical flow equation. 
%
%   Description :  
%
%   -image1, image2 :   two subsequent images or frames
%   -r : radius of the neighbourhood, default value is 2. 
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

%  Default parameter
if nargin==2
    r=2;
end

[height,width,depth]=size(image1); 
image1=im2double(image1);
image2=im2double(image2);

% Initializing flow vectors
ux=zeros(size(image1)); uy=ux; uz=ux;

% Computing image derivatives
[Ix,Iy,Iz,It]=imageDerivatives3D(image1,image2);

for i=(r+1):(height-r)
    for j=(r+1):(width-r)
        for k=(r+1):(depth-r)
        
        blockofIx=Ix(i-r:i+r,j-r:j+r,k-r:k+r);
        blockofIy=Iy(i-r:i+r,j-r:j+r,k-r:k+r);
        blockofIz=Iz(i-r:i+r,j-r:j+r,k-r:k+r);
        blockofIt=It(i-r:i+r,j-r:j+r,k-r:k+r);

               
        A=zeros(3,3);
        B=zeros(3,1);
        
        A(1,1)=sum(sum(sum(blockofIx.^2)));
        A(1,2)=sum(sum(sum(blockofIx.*blockofIy)));
        A(1,3)=sum(sum(sum(blockofIx.*blockofIz)));
        
        A(2,1)=sum(sum(sum(blockofIy.*blockofIx)));
        A(2,2)=sum(sum(sum(blockofIy.^2)));
        A(2,3)=sum(sum(sum(blockofIy.*blockofIz)));

        A(3,1)=sum(sum(sum(blockofIz.*blockofIx)));
        A(3,2)=sum(sum(sum(blockofIz.*blockofIy)));
        A(3,3)=sum(sum(sum(blockofIz.^2)));
       
        B(1,1)=sum(sum(sum(blockofIx.*blockofIt)));
        B(2,1)=sum(sum(sum(blockofIy.*blockofIt)));
        B(3,1)=sum(sum(sum(blockofIz.*blockofIt)));
        
        invofA=pinv(A);
        
        V=invofA*(-B);
        ux(i,j,k)=V(1,1);
        uy(i,j,k)=V(2,1);
        uz(i,j,k)=V(3,1);
        end
    end
end

end

