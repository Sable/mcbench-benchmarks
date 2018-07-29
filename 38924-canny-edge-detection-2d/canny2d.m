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

%% This function was based on GAGAN's canny edge detection MATLAB function which is available @
%% http://www.mathworks.com/matlabcentral/fileexchange/30621-canny-edge-detection
%% Deshan Yang, PhD, Washington University in Saint Louis


function [gnh,gnl]= canny2d(img,si,sigma,thresh)
%% input argument check.

narginchk(4,4);
if(thresh(1)>1 || thresh(1)<0)
 error('Thresh value(s) should be between 0 and 1');
end

if ischar(img)
    I=imread(img);
    if(size(I,3)==3)
        I=rgb2gray(I);
    end
else
    I = img;
end

dim=size(I);

figure,imagesc(I),axis image;impixelinfo,title('Original Image'),colormap('gray');

if length(thresh)==1
    lthresh=0.4*thresh;
    uthresh=thresh;
else
    uthresh=thresh(1);
    lthresh=thresh(2);
end

if(uthresh>1.0)
    uthresh=1;
end
%% Antialias the image by convolving with gaussian filter

h=fspecial('gaussian',si,sigma);
I=im2double(I);
I=imfilter(I,h,'conv');
figure,imagesc(I),axis image;impixelinfo,title('Original Image after Convolving with gaussian'),colormap('gray');
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
figure,imagesc(Mag),axis image;impixelinfo,title('Magnitude of gradient Vectors'),colormap('gray');
gnl=zeros(dim(1),dim(2));
gnh=zeros(dim(1),dim(2));
% figure,quiver(20*Ix,20*Iy,0),axis image,title('Orientation of gradient vectors'),colormap('gray');


% %% Apply non maxima suppression and thresholding. The orientation of gradient vecctor is
% %% resolved into four directions.
% tic;
% angle=atand(Iy./Ix);
% for y=2:1:size(I,1)-1
%     for x=2:1:size(I,2)-1
%         if(((angle(y,x)>=-22.5)&&(angle(y,x)<22.5))||((angle(y,x)<-157.5))||(angle(y,x)>157.5))
%             if((Mag(y,x)>Mag(y,x+1)) && (Mag(y,x)>Mag(y,x-1)))
%                 if(Mag(y,x)>=lthresh)
%                     if(Mag(y,x)>=uthresh)
%                         gnh(y,x)=1;
%                     else
%                         gnl(y,x)=1;
%                     end
%                 end
%             end
%         end
%         if(((angle(y,x)>=-112.5)&&(angle(y,x)<-67.5))||((angle(y,x)>=67.5)&&(angle(y,x)<112.5)))
%             if((Mag(y,x)>Mag(y+1,x)) && (Mag(y,x)>Mag(y-1,x)))
%                 if(Mag(y,x)>=lthresh)
%                     if(Mag(y,x)>=uthresh)
%                         gnh(y,x)=1;
%                     else
%                         gnl(y,x)=1;
%                     end
%                 end
%             end
%         end
%         if(((angle(y,x)>=-67.5)&&(angle(y,x)<-22.5))||((angle(y,x)>=112.5)&&(angle(y,x)<157.5)))
%             if((Mag(y,x)>Mag(y-1,x+1)) && (Mag(y,x)>Mag(y+1,x-1)))
%                 if(Mag(y,x)>=lthresh)
%                     if(Mag(y,x)>=uthresh)
%                         gnh(y,x)=1;
%                     else
%                         gnl(y,x)=1;
%                     end
%                 end
%             end
%         end
%         if(((angle(y,x)>=-157.5)&&(angle(y,x)<-112.5))||((angle(y,x)>=22.5)&&(angle(y,x)<67.5)))
%             if((Mag(y,x)>Mag(y+1,x+1)) && (Mag(y,x)>Mag(y-1,x-1)))
%                 if(Mag(y,x)>=lthresh)
%                     if(Mag(y,x)>=uthresh)
%                         gnh(y,x)=1;
%                     else
%                         gnl(y,x)=1;
%                     end
%                 end
%             end
%         end
%     end
% end
% time1=toc;
% figure,imagesc(gnh);axis image;
% impixelinfo,title('Image after thresholding'),colormap('gray');

%% A different way to perform non-maxima supression
%% Completely in matrix format, no if-then statements, according to my test, the new way is 50 times faster.

% tic;
idxes = find(Mag>lthresh);
theta = cart2pol(Ix(idxes),Iy(idxes));
theta = theta/pi*180;
direction = floor(mod(theta+22.5,180)/45)+1;
deltax = [1 1 0 -1];
deltay = [0 1 1 1];
deltaxs = deltax(direction)';
deltays = deltay(direction)';

[yis,xis] = ind2sub(dim,idxes);
yis1=yis+deltays; yis1=max(yis1,1); yis1=min(yis1,dim(1));
yis2=yis-deltays; yis2=max(yis2,1); yis2=min(yis2,dim(1));
xis1=xis+deltaxs; xis1=max(xis1,1); xis1=min(xis1,dim(2));
xis2=xis-deltaxs; xis2=max(xis2,1); xis2=min(xis2,dim(2));
idxes1 = sub2ind(dim,yis1,xis1);
idxes2 = sub2ind(dim,yis2,xis2);

Mag1 = Mag(idxes1);
Mag2 = Mag(idxes2);
Mag0 = Mag(idxes);
idxes_gnh = idxes(Mag0>Mag1 & Mag0>Mag2 & Mag0>=uthresh);
idxes_gnl = idxes(Mag0>Mag1 & Mag0>Mag2 & Mag0<uthresh);

gnh(idxes_gnh)=1;
gnl(idxes_gnl)=1;

% time2=toc;
% fprintf('Time 1 and 2 = %.5f, %0.5f\n',time1,time2);
figure,imagesc(gnh);axis image;
impixelinfo,title('Image after thresholding'),colormap('gray');


%% Apply Connectivity Analysis.
% gnh2 = gnh;
% gnl2 = gnl;
% tic;
% while(1)
%     gnh_save = gnh;
%     [row,col]=find(gnh>0);
%     for t=1:1:size(col)
%         if(row(t)<dim(1) && gnl(row(t)+1,col(t))>0)
%             gnh(row(t)+1,col(t))=1;
%             gnl(row(t)+1,col(t))=0;
%         end
%         if(col(t)<dim(2) && gnl(row(t),col(t)+1)>0)
%             gnh(row(t),col(t)+1)=1;
%             gnl(row(t),col(t)+1)=0;
%         end
%         if(row(t)<dim(1) && col(t)<dim(2) && gnl(row(t)+1,col(t)+1)>0)
%             gnh(row(t)+1,col(t)+1)=1;
%             gnl(row(t)+1,col(t)+1)=0;
%         end
%         if(row(t)>1 && col(t)>1 && gnl(row(t)-1,col(t)-1)>0)
%             gnh(row(t)-1,col(t)-1)=1;
%             gnl(row(t)-1,col(t)-1)=0;
%         end
%         if(row(t)<dim(1) && col(t)>1 && gnl(row(t)+1,col(t)-1)>0)
%             gnh(row(t)+1,col(t)-1)=1;
%             gnl(row(t)+1,col(t)-1)=0;
%         end
%         if(row(t)>1 && col(t)<dim(2) && gnl(row(t)-1,col(t)+1)>0)
%             gnh(row(t)-1,col(t)+1)=1;
%             gnl(row(t)-1,col(t)+1)=0;
%         end
%         if(row(t)>1 && gnl(row(t)-1,col(t))>0)
%             gnh(row(t)-1,col(t))=1;
%             gnl(row(t)-1,col(t))=0;
%         end
%         if(col(t)>1 && gnl(row(t),col(t)-1)>0)
%             gnh(row(t),col(t)-1)=1;
%             gnl(row(t),col(t)-1)=0;
%         end
%     end
%     
%     if isequal(gnh,gnh_save)
%         break;
%     end
% end
% time3=toc;
% fprintf('Time 3 = %.5f.\n',time3);
% figure,imagesc(I);axis image;impixelinfo;title('Image after Applying Connectivity Analysis'),colormap('gray');
% hold on;contour(gnh,[0.5 0.5],'LineColor','r');

%% Apply Connectivity Analysis, new method, it is about 400 times faster
% tic;
[row,col]=find(gnh>0);
idxes = (col-1)*dim(1)+row;
gnl(gnh==1)=1;
gnh = imfill(gnl==0,idxes,8)-(gnl==0);
% time4=toc;
% fprintf('Time 4 = %.5f.\n',time4);

%% Display output Image.
figure,imagesc(I);axis image;impixelinfo;title('Image after Applying Connectivity Analysis'),colormap('gray');
hold on;contour(gnh,[0.5 0.5],'LineColor','r');
end
