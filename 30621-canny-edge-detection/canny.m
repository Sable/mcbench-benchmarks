%% This function applies Canny Operator to an input
%% image and can be used for edge detection.


%%% input arguments
%% image = String representing input file.
%% si = Size of Gaussian Kernel used for antialiasing the input image and calculating
%%      gaussian derivatives.
%% sigma = Standard deviation of Gaussian function.
%% thresh = upper threshold used for thresholding in Canny method.

%%% output Arguments
%% gnh = output Image.

%%% References :- DIGITAL IMAGE PROCESSING Third Edition,
%%                Rafael C. Gonzalez
%%                Richard E. Woods




function gnh= canny(image,si,sigma,thresh)
%% input argument check.

error(nargchk(4,4,nargin));
if(thresh>1)
 error('Thresh value should be between 0 and 1');
end
I=imread(image);
if(size(I,3)==3)
I=rgb2gray(I);
end
figure,imagesc(I),impixelinfo,title('Original Image'),colormap('gray');
lthresh=0.4*thresh;
uthresh=thresh;
if(uthresh>1.0)
    uthresh=1;
end
%% Antialias the image by convolving with gaussian filter

h=fspecial('gaussian',si,sigma);
I=im2double(I);
I=imfilter(I,h,'conv');
figure,imagesc(I),impixelinfo,title('Original Image after Convolving with gaussian'),colormap('gray');
%% Compute Gaussian derivatives

 x=-si:1:si;
 y=-si:1:si;
gaussx=-(x/(sigma*sigma)).*exp(-(x.*x+y.*y)/(2*sigma*sigma));
gaussy=gaussx';
Ix=imfilter(I,gaussx,'conv');
Iy=imfilter(I,gaussy,'conv');
%% Compute magnitude and orientation of gradient vector.

Mag=sqrt(Ix .^ 2 + Iy .^ 2);
Magmax=max(Mag(:));
Mag=Mag/Magmax;
figure,imagesc(Mag),impixelinfo,title('Magnitude of gradient Vectors'),colormap('gray');
gnl=zeros(size(I,1),size(I,2));
gnh=zeros(size(I,1),size(I,2));
angle=atand(Iy./Ix);
figure,quiver(20*Ix,20*Iy,0),title('Orientation of gradient vectors'),colormap('gray');
%% Apply non maxima suppression and thresholding. The orientation of gradient vecctor is
%% resolved into four directions.

for y=2:1:size(I,1)-1
    for x=2:1:size(I,2)-1
        if(((angle(y,x)>=-22.5)&&(angle(y,x)<22.5))||((angle(y,x)<-157.5))||(angle(y,x)>157.5))
            if((Mag(y,x)>Mag(y,x+1)) && (Mag(y,x)>Mag(y,x-1)))
                if(Mag(y,x)>=lthresh)
                    if(Mag(y,x)>=uthresh)
                gnh(y,x)=1;
                    else
                    gnl(y,x)=1;
                    end
                end
            end
        end
        if(((angle(y,x)>=-112.5)&&(angle(y,x)<-67.5))||((angle(y,x)>=67.5)&&(angle(y,x)<112.5)))
            if((Mag(y,x)>Mag(y+1,x)) && (Mag(y,x)>Mag(y-1,x)))
                if(Mag(y,x)>=lthresh)
                    if(Mag(y,x)>=uthresh)
                gnh(y,x)=1;
                    else
                    gnl(y,x)=1;
                    end
                end
            end
        end
        if(((angle(y,x)>=-67.5)&&(angle(y,x)<-22.5))||((angle(y,x)>=112.5)&&(angle(y,x)<157.5)))
            if((Mag(y,x)>Mag(y-1,x+1)) && (Mag(y,x)>Mag(y+1,x-1)))
                if(Mag(y,x)>=lthresh)
                    if(Mag(y,x)>=uthresh)
                gnh(y,x)=1;
                    else
                    gnl(y,x)=1;
                    end
                end
            end
        end
        if(((angle(y,x)>=-157.5)&&(angle(y,x)<-112.5))||((angle(y,x)>=22.5)&&(angle(y,x)<67.5)))
            if((Mag(y,x)>Mag(y+1,x+1)) && (Mag(y,x)>Mag(y-1,x-1)))
                if(Mag(y,x)>=lthresh)
                    if(Mag(y,x)>=uthresh)
                gnh(y,x)=1;
                    else
                    gnl(y,x)=1;
                    end
                end
            end
        end
    end
end
figure,imagesc(gnh),impixelinfo,title('Image after thresholding'),colormap('gray');
%% Apply Connectivity Analysis.

[row,col]=find(gnh>0);
    for t=1:1:size(col)
        if(gnl(row(t)+1,col(t))>0)
            gnh(row(t)+1,col(t))=1;
            gnl(row(t)+1,col(t))=0;
        end
        if(gnl(row(t),col(t)+1)>0)
            gnh(row(t),col(t)+1)=1;
            gnl(row(t),col(t)+1)=0;
        end
        if(gnl(row(t)+1,col(t)+1)>0)
            gnh(row(t)+1,col(t)+1)=1;
            gnl(row(t)+1,col(t)+1)=0;
        end
        if(gnl(row(t)-1,col(t)-1)>0)
            gnh(row(t)-1,col(t)-1)=1;
            gnl(row(t)-1,col(t)-1)=0;
        end
        if(gnl(row(t)+1,col(t)-1)>0)
            gnh(row(t)+1,col(t)-1)=1;
            gnl(row(t)+1,col(t)-1)=0;
        end
        if(gnl(row(t)-1,col(t)+1)>0)
            gnh(row(t)-1,col(t)+1)=1;
            gnl(row(t)-1,col(t)+1)=0;
        end
        if(gnl(row(t)-1,col(t))>0)
            gnh(row(t)-1,col(t))=1;
            gnl(row(t)-1,col(t))=0;
        end
        if(gnl(row(t),col(t)-1)>0)
            gnh(row(t),col(t)-1)=1;
            gnl(row(t),col(t)-1)=0;
        end
    end
    %% Display output Image.
    
figure,imagesc(gnh),impixelinfo,title('Image after Applying Connectivity Analysis'),colormap('gray');
end