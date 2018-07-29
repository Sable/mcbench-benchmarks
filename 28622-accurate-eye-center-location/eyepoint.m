function [ro,c] = eyepoint(input,kernelsize,sigma,minrad,maxrad,varargin)
%Finds the center of a human eye in
%a grayscale or rgb image using isophote curvature
%Reference: Accurate Eye Center Location and Tracking Using Isophote
%Curvature, Roberto Valenti and Theo Gevers





% %%%%%% Input Arguments
% input = Either Grayscale or RGB image.
% kernelsize = size of Gaussian kernel used for smoothing and filtering the
% image.
% sigma = Standard deviation of gaussian filter.
% minrad = minimum value of magnitude of displacement vector estimated using the method that
% should be used for voting. Values below it are not used for voting.
% maxrad = maximum value of magnitude of displacement vector estimated
% using  the method that should be used for voting. Values above it are not
% used for center voting.
% thresh (Not required when using curved method. but required during using
% canny method
%)= threshhold value as required for Canny operator in Edge method. Default
%is 0.37
%scale(optional)=To specify which scale to use. Default is 1.
% method(optional)= Method to be used for determinin center. can be string named
% 'canny' or 'curved'. default is 'curved'.


% %%%%%% Output Arguments
% r = y-coordinates of estimated center.
% c =x-coordinates of estimated center.


% %%%%% Example:
% eyepoint('C:\Singh\Data\faces\BioID\ftp.uni-erlangen.de\pub\facedb\BioID_
% 1152.png',8,3,4,30,0.37,'canny');

% eyepoint('C:\Singh\Data\faces\BioID\ftp.uni-erlangen.de\pub\facesdb\BioID
% _1152.png',8,5,4,30);
%eyepoint('C:\highres\008\008_01.jpg',8,1,4,50,0.5)
%eyepoint('C:\highres\032\032_01.jpg',8,1,5,50,0.43,'canny')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Validate the input arguments
strarray{1}='curved';
strarray{2}='canny';
error(nargchk(5,8,nargin));
% If number of input arguments is 8.
if(nargin==8)
method=validatestring(varargin{3},strarray);
thresh=varargin{1}(:);
scale=varargin{2}(:);
end
if(nargin==7)
    if(ischar(varargin{2}(:)))
        method=validatestring(varargin{2},strarray);
    if(strmatch(method,'curved','exact'))
        scale=varargin{1}(:);
    else 
        thresh=varargin{1}(:);
        scale=1;
    end
    else
        method='curved';
        thresh=varargin{1}(:);
        scale=varargin{2}(:);
    end
end
if(nargin==6)
    if(ischar(varargin{1}(:)))
        method=validatestring(varargin{1},strarray);
        if(strmatch(method,'curved','exact'))
            scale=1;
        else
            thresh=0.37;
            scale=1;
        end
    else
    method='curved';
    scale=varargin{1}(:);
    end
end
% Read the image
I=imread(input);
iptsetpref('useIPPL',false);
scale
if(scale~=1)
I=imresize(I,scale,'lanczos3');
end
% If the image is rgb then convert it into grayscale
if(size(I,3)==3)
I=rgb2gray(I);
end
imagesc(I),title('Original Image'),impixelinfo,colormap('gray');
hold on;
% Crop the image and adjust it. It saves computation and makes sure that only relevant areas
% of the Image are used.
K=imadjust(I,stretchlim(I),[]);
[J,rect]=imcrop(K);
hold off;
m=[rect(1) rect(1)+rect(3)];
n=[rect(2) rect(2)+rect(4)];
% Display the cropped image
figure,imagesc(J,'XData',m,'YData',n),title('Original Cropped Image'),impixelinfo,colormap('gray');
% Obtain the kernel for smoothing the image using the given arguments 
sz=2*kernelsize-1;
h=zeros(2*sz-1,2*sz-1);
for y=-(sz-1):1:(sz-1)
    for x=-(sz-1):1:(sz-1)
      a=x+sz;
      b=y+sz;
      h(b,a)=exp(-((x*x) + (y*y))/(2*sigma*sigma))/(2*pi*sigma*sigma);
    end
end
% smooth the image using imfilter function and kernel obtained above
% Apply the canny operator on the image if specified
if(strmatch(method,'canny','exact'))
J=imfilter(J,h,'replicate','conv');
J=edge(J,'canny',thresh,sigma);
end
% Convert the data type of the image to double. Now divide the cropped
% image into two parts. One for each eye. Store it in variable cel
cel{1}=J(1:1:size(J,1),1:1:round(0.50*size(J,2)));
cel{2}=J(1:1:size(J,1),round(0.50*size(J,2)):1:size(J,2));
ro=zeros(2);
c=zeros(2);
%for each eye apply the algorithm based on the method specified.
for gagan=1:1:2
cel{gagan}=im2double(cel{gagan});
% Smooth the image.
cel{gagan}=imfilter(cel{gagan},h,'replicate','conv');
% Display the image obtained after
% smoothing
figure,imagesc(cel{gagan},'XData',m,'YData',n),title('Image after Blurring with Gaussian'),impixelinfo,colormap('gray');
% Calculate the gradient using the 7-tap Coefficients given by Farid and
% Simoncelli given in their paper "Differentiation of Discrete
% Multi-Dimensional Signals".If scale is les than or equal to 1. Otherwise
% compute using gradient method of MATLAB.
if(scale<=1)
 p = [ 0.004711  0.069321  0.245410  0.361117  0.245410  0.069321  0.004711];
  d1 = [ 0.018708  0.125376  0.193091  0.000000 -0.193091 -0.125376 -0.018708];
  d2 = [ 0.055336  0.137778 -0.056554 -0.273118 -0.056554  0.137778  0.055336];
 FX=conv2(p,d1,cel{gagan},'same');
 FY=conv2(d1,p,cel{gagan},'same');
 FXX=conv2(p,d2,cel{gagan},'same');
 FYY=conv2(d2,p,cel{gagan},'same');
 FXY=conv2(d1,p,FX,'same');
else
[FX,FY]=gradient(cel{gagan});
[FXX,FXY]=gradient(FX);
[FYX,FYY]=gradient(FY);
end
% Calculate the curvedness
curved=sqrt(im2double(FXX.^2 + 2*FXY.^2 + FYY.^2));
% Display the curvedness
figure,imagesc(abs(curved),'XData',m,'YData',n),title('Curvedness'),impixelinfo,colormap('gray');
% Calculate the displacement vectors
G1=FX.^2 + FY.^2;
G2=((FY.^2).*FXX) - (2*(FX.*FXY).*FY) + ((FX.^2).*FYY);
G2=round(G1./G2);
G2=-1*G2;
% Clear the redundant variables to free some space
clear FXX;
clear FXY;
clear FYY;
G4=G2.*FX;
G5=G2.*FY;
G1=G1.^(1.5);
G8=round(G2./G1);
G8=-1*G8;
clear FX;
clear FY;
D_vector=zeros(size(cel{gagan},1),size(cel{gagan},2),2);
for y=1:1:size(cel{gagan},1)
for x=1:1:size(cel{gagan},2)
        D_vector(y,x,1)=G4(y,x);
        D_vector(y,x,2)=G5(y,x);
end
end
D_vector=round(D_vector);
Mag_D_vector=sqrt(D_vector(:,:,1).^2 + D_vector(:,:,1).^2);
% Create the weight array.Make curvedness as the voting scheme if method
% specified is curved otherwise use 1 for canny.
weight=zeros(size(cel{gagan},1),size(cel{gagan},2));
for y=1:1:size(cel{gagan},1)
    for x=1:1:size(cel{gagan},2)
        if(strmatch(method,'canny','exact'))
            weight(y,x)=1;
        else
      weight(y,x)=abs(curved(y,x));
    end
    end
end
% Create the accumulator that will store the result
mapped=zeros(size(cel{gagan},1),size(cel{gagan},2));
Used_D_Vector=zeros(size(cel{gagan},1),size(cel{gagan},2),2);
for y=1:1:size(cel{gagan},1)
    for x=1:1:size(cel{gagan},2)
        if((D_vector(y,x,1)~=0) || (D_vector(y,x,2)~=0))
        if((x+D_vector(y,x,1)>0) &&  (y+D_vector(y,x,2)>0))
        if((x+D_vector(y,x,1)<=size(cel{gagan},2)) &&  (y+D_vector(y,x,2)<=size(cel{gagan},1)) && (G8(y,x)<0))
            if((Mag_D_vector(y,x)>=minrad)&&(Mag_D_vector(y,x)<=maxrad))
                % use only those displacement vectors which are within the
                % specified range
            Used_D_Vector(y,x,1)=D_vector(y,x,1);
            Used_D_Vector(y,x,2)=D_vector(y,x,2);  
        mapped(y+D_vector(y,x,2),x+D_vector(y,x,1))=mapped(y+D_vector(y,x,2),x+D_vector(y,x,1)) + weight(y,x);
            end
        end
        end
        end
    end
end
% plot the used displacement vectors
quiver(Used_D_Vector(:,:,1),Used_D_Vector(:,:,2),0),title('Displacement Vector');
% smooth the accumulator
mapped=imfilter(mapped,h,'replicate','conv');
% plot the mapped image obtained after smoothing
figure,imagesc(mapped,'XData',m,'YData',n),title('Mapped Image after Blurring with Gaussian'),impixelinfo,colormap('gray');
% Find the maximum isocenter
[ro(gagan),c(gagan)]=find(mapped==max(mapped(:)));
mapped(mapped<max(mapped(:)))=0;
% plot the result
figure,imagesc(mapped,'XData',m,'YData',n),title('Result'),impixelinfo,colormap('gray');
% Back project to see who voted for the center
radiusmap{gagan}=zeros(size(cel{gagan},1),size(cel{gagan},2));
for y=1:1:size(cel{gagan},1)
    for x=1:1:size(cel{gagan},2)
            if(((ro(gagan)-2)<=(y+Used_D_Vector(y,x,2)))&&((ro(gagan)+2)>=(y+Used_D_Vector(y,x,2))) && ((c(gagan)-2)<=(x+Used_D_Vector(y,x,1)))&&((c(gagan)+2)>=(x+Used_D_Vector(y,x,1))))
                radiusmap{gagan}(y,x)=radiusmap{gagan}(y,x) + abs(curved(y,x));
            end
    end
 end
figure,imagesc(abs(curved),'XData',m,'YData',n),title('Curvedness'),impixelinfo,colormap('gray');
% plot the back projected image
figure,imagesc(radiusmap{gagan},'XData',m,'YData',n),title('Radiusmap'),impixelinfo,colormap('gray');
end
c(1)=c(1)+m(1);
ro(1)=ro(1)+n(1);
c(2)=c(2)+m(1)+0.50*size(J,2);
ro(2)=ro(2)+n(1);
% Display the resulting image.
figure;imshow(I,[],'initialMagnification','fit');impixelinfo;hold on;
plot(c(1),ro(1),'r*');
plot(c(2),ro(2),'r*');
c(1),ro(1)
c(2),ro(2)
hold off;
end