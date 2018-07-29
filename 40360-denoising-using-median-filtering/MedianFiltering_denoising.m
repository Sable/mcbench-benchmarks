clc;
clear all;
close all;
im=imread('cameraman.tif');
figure,imshow(im)
J=imnoise(im,'salt & pepper');
L=J;
figure,imshow(L)
[s1,s2]=size(im);
b=0;
m=input('Enter number of rows of the mask: ');
n=input('Enter number of columns of the mask: ');
if (mod(m,2)~=0 && mod(n,2)~=0)
    for y=1:s1-m+1
        for x=1:s2-n+1
            bottom = y;top=y+m-1;left = x;right =x+n-1;
            croppedImage = J(bottom:top, left:right);
            b=sort(reshape(croppedImage,1,m*n),'ascend');
            t=b((m*n+1)/2);
            J(y-1+(m+1)/2,x-1+(n+1)/2)=t;
        end
    end
    figure,imshow(J)
    
    get_PSNR(im,L)
    get_PSNR(im,J)
else
    display('Rows and Columns must be odd numbers');
end


