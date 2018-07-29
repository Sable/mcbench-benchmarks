% clear all;
% clc;
% a=[1,2,3,4;4,5,6,9;2,5,6,5;5 2 8 6];
% [filename,pathname]=uigetfile('*.jpg')
% a=imread(strcat(pathname,filename));
% % a=imread('imag.jpg');

function [v,w]=haaar(a)
a=rgb2gray(a);
a=imresize(a,[512 512]);
% z=a;
% disp('enter the level of pyramid');
% l=input('');
prompt={'enter the level of pyramid'};
dlg='enter 1 to 8';
l=cell2mat(inputdlg(prompt,dlg));
l= sscanf(l,'%f');
f=1;
for p=1:l
[r,c]=size(a);
z=a;
    for i=1:1:r
        k=1;
        t=(r/2+1);
        for j=1:2:c
            avg=(a(i,j)+a(i,j+1))/2;
            dif=(a(i,j)-a(i,j+1))/2;
            z(i,k)=avg;
            z(i,t)=dif;
            k=k+1;
            t=t+1;
        end
    end
    a=z;
    for j=1:1:c
        t=(r/2+1);
        k=1;
        for i=1:2:r
            avg=(a(i,j)+a(i+1,j))/2;
            dif=(a(i,j)-a(i+1,j))/2;
            z(k,j)=avg;
            z(t,j)=dif;
            k=k+1;
            t=t+1;
        end
    end
    if p==1;
        v=z;
    else
    v(1:512/(2^f),1:512/(2^f))=z;
    f=f+1;
    end
    a=z(1:512/(2^p),1:512/(2^p));
end
a=imresize(a,[512 512]);
% figure();
w=a;
% imshow(v);figure();
% imshow(a);
%     

            
            

