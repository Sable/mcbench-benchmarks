%Program for creating generalised Sobel operator
%Authors : Jeny Rajan, K.Kannan
%Medical Imaging Research Group, NeST, Trivandrum 
%http://jenyrajan.googlepages.com/
%http://kannan.keizer.googlepages.com/kannankeizer 

%This program can be used to generate sobel filter of any order
% Usage  [E Mx My]=Gsobel(img,Wsize)
% eg. [E Mx My]=Gsobel(img,5)
% E - Resultant Edge image generated with sobel filter of window size Wsize
% Mx & My  - Horizontal and Vertical Masks 
% img - input image
% Wsize - Filter window size

function [E Mx My]= GSobel(img,Wsize)
for i=1:Wsize
    Sx(i)=factorial((Wsize-1))/((factorial((Wsize-1)-(i-1)))*(factorial(i-1)));
    Dx(i)=Pasc(i-1,Wsize-2)-Pasc(i-2,Wsize-2);
end
Sy=Sx';
Dy=Dx';
Mx=Sy(:)*Dx;
My=Mx';
Ey=imfilter(double(img),My,'symmetric');
Ex=imfilter(double(img),Mx,'symmetric');
E=sqrt(Ex.^2+Ey.^2);
figure,imshow(img,[]),title('Original Image');
figure,imshow(E,[]),title('Edge Image');

function P=Pasc(k,n)
if (k>=0)&&(k<=n)
    P=factorial(n)/(factorial(n-k)*factorial(k));
else
    P=0;
end

