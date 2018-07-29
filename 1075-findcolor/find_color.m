function [image,index]=find_color(image,map,tr,colors) 
%[IMAGE,IND]=FIND_COLOR(A,MAP,THRESHOLD,COLOR VECTOR) 
%Finds a color of an Image A and returns IMAGE, the 
%original image with the pixels with the specified color set 
%to zero, and IND, an index to the pixels that are were 
%equal to the selected color.
%
%MAP is the input if the image is indexed, if the image is not indexed
%enter empty brackerts ( [] ), TR is the threshold tolerance for the 
%color range, COLOR VECTOR is an additional argument that takes 
%in the hard-coded values for the color, use empty brackects ( [] )
%if you wish to select the color from the origimal image using the mouse.
%
%Composite image, EXAMPLE:
%x=imread('football.jpg');
%subplot(2,1,1);imshow(x);
%title('Before');
%[image,ind]=find_color(x,[],90,[27 80 111]);
%subplot(2,1,2);imshow(image);
%title('After')
%figure
% y=imread('saturn.tif');
% image(328,438,:)=0;
% i= ~(im2bw(image,0.01));
% c=immultiply(y,i);
% c(:,:,2)=c;
% c(:,:,3)=c(:,:,2);
% y(:,:,2)=y;
% y(:,:,3)=y(:,:,1);
% C=imadd(image,c);
% imshow(C)


%by is



I=make_rgb(image,map); 

if isempty(colors)
disp('Right click on the color you want off the image with the mouse:') ;

colors=impixel(I); 
close 
end

[i j]=size(colors);


disp('Wait....');


if i>1,
    colors=colors(1,:);
end
[image,index]= getcolor(I,colors,tr);


disp('Done')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [image,index]=getcolor(I,color,tr)
 
[i j k]=size(I);
R=color(1,1);
G=color(1,2);
B=color(1,3);
I=double(I);

mask=( abs(I(:,:,1)-R) <tr ) & ( abs(I(:,:,2)-G) <tr ) &( abs(I(:,:,3)-B) <tr );

I(:,:,1)=I(:,:,1).*(~mask);
I(:,:,2)=I(:,:,2).*(~mask);
I(:,:,3)=I(:,:,3).*(~mask);

image=uint8(I);
index=find(mask==1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function I=make_rgb(image,map) 

[i j k]=size(image);

if (~isempty(map)), 
    I=ind2rgb(image,map); 
    I=im2uint8(I);

elseif (isempty(k)), 
    I(:,:,2)=I; 
    I(:,:,3)=I(:,:,1); 
    
else
I=image;
end

