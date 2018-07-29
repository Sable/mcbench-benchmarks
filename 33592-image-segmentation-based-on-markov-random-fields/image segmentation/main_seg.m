clc
clear

I=imread('peppers.png');
I=double(I);
class_number=3;
potential=0.5;
maxIter=30;
seg=ICM(I,class_number,potential,maxIter);
figure;
imshow(I);