close all; 
clear all; 
clc;

file = input('please enter the image file name:','s');  

I = imread(file);
flg=isrgb(I);             %imgenin renk uzayý test ediliyor. ( Testing the color space)

if flg==1
    I=rgb2gray(I);
end

[h,w]=size(I);
figure;imshow(I);

c = edge(I, 'canny',0.3);  % mcanny kenar algýlama fonksiyonu (Mcanny edge detection)
figure; imshow(c);         % ikili imge olarak kenar tespiti (binary edges)

se = strel('disk',2);      %
I2 = imdilate(c,se);       % pupil bölgesinin tespiti aþamasý 
imshow(I2);                %

d2 = imfill(I2, 'holes');  % pupil bölgesi alan tespiti
figure, imshow(d2);        %

Label=bwlabel(d2,4);

a1=(Label==1);
a2=(Label==2);
a3=(Label==3);
a4=(Label==4);
a5=(Label==5);
a6=(Label==6);

D1 = bwdist(~a1);           % computing minimal euclidean distance to non-white pixel 
figure, imshow(D1,[]),      %  
[xc1 yc1 r1]=merkz(D1);
f1=coindetect(r1)


D2 = bwdist(~a2);           % computing minimal euclidean distance to non-white pixel 
figure, imshow(D2,[]),      %  
[xc2 yc2 r2]=merkz(D2);
f2=coindetect(r2)

D3 = bwdist(~a3);           % computing minimal euclidean distance to non-white pixel 
figure, imshow(D3,[]),      %  
[xc3 yc3 r3]=merkz(D3);
f3=coindetect(r3)

D4 = bwdist(~a4);           % computing minimal euclidean distance to non-white pixel 
figure, imshow(D4,[]),      %  
[xc4 yc4 r4]=merkz(D4);
f4=coindetect(r4)

D5 = bwdist(~a5);           % computing minimal euclidean distance to non-white pixel 
figure, imshow(D5,[]),      %  
[xc5 yc5 r5]=merkz(D5);
f5=coindetect(r5)

D6 = bwdist(~a6);           % computing minimal euclidean distance to non-white pixel 
figure, imshow(D6,[]),      %  
[xc6 yc6 r6]=merkz(D6);
f6=coindetect(r6)