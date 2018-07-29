function [ux,uy,uz] = refinedLK3D(uxIn,uyIn,uzIn,image1,image2,r,sigma)
%This function refines Lucas-Kanade 3-D optical flow using previous estimates. 
%
%   Description :
%
%   -uxIn,uyIn,uzIn : initial estimates of optical flow along 3 principal axes.
%   -image1, image2 : two subsequent images or frames.
%   -r : redius of neighbourhood, default value is 2.
%   -sigma : standard deviation of Gaussian function, default value is 0.5.
%   -ww : wighted window used in least square equation; it gives more
%         weight to the central pixel.
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
if nargin==5
    r=2; sigma=0.5;
elseif nargin==6
    sigma=0.5;
end

% displacment vectors should have round numbers of displacement along axes.
uxIn=round(uxIn); uyIn=round(uyIn); uzIn=round(uzIn);

s=size(image1);

% Initializing flow vectors 
ux=zeros(s); uy=ux; uz=ux;

% Gaussian wighted window to be used in least square equation
ww=gaussianKernel3D(r,sigma);

for i=r+1:s(1)-r
    for j=r+1:s(2)-r
        for k=r+1:s(3)-r
        currentImage1=image1(i-r:i+r,j-r:j+r,k-r:k+r); 

        %using initial displacement vectors for refinement
            % for X axis
        minC=uxIn(i,j,k)+j-r; 
        maxC=uxIn(i,j,k)+j+r;
            % for Y axis        
        minR=uyIn(i,j,k)+i-r;
        maxR=uyIn(i,j,k)+i+r;
            % for Z axis
        minD=uzIn(i,j,k)+k-r;
        maxD=uzIn(i,j,k)+k+r;

        if minR>=1 && maxR<=s(1) && minC>=1 && maxC<=s(2) ...
                && minD>=1 && maxD<=s(3)
            currentImage2=image2(minR:maxR,minC:maxC,minD:maxD);
            
            [Ix,Iy,Iz,It]=imageDerivatives3D(currentImage1,currentImage2);

            % least square equation with weighted window
            A=zeros(3,3);
            B=zeros(3,1);
            A(1,1)=sum(sum(sum((Ix.^2).*ww )));
            A(1,2)=sum(sum(sum((Ix.*Iy).*ww )));
            A(1,3)=sum(sum(sum((Ix.*Iz).*ww )));
        
            A(2,1)=sum(sum(sum((Iy.*Ix).*ww )));
            A(2,2)=sum(sum(sum((Iy.^2).*ww )));
            A(2,3)=sum(sum(sum((Iy.*Iz).*ww )));

            A(3,1)=sum(sum(sum((Iz.*Ix).*ww )));
            A(3,2)=sum(sum(sum((Iz.*Iy).*ww )));
            A(3,3)=sum(sum(sum((Iz.^2).*ww )));
       
            B(1,1)=sum(sum(sum((Ix.*It).*ww )));
            B(2,1)=sum(sum(sum((Iy.*It).*ww )));
            B(3,1)=sum(sum(sum((Iz.*It).*ww )));
    
            invofA=pinv(A);
    
            V=invofA*(-B);
            ux(i,j,k)=V(1,1);
            uy(i,j,k)=V(2,1);
            uz(i,j,k)=V(3,1);
        end
        end
    end
end
ux=ux+uxIn; 
uy=uy+uyIn;
uz=uz+uzIn;

end

