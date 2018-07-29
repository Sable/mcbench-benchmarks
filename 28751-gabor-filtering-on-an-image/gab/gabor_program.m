% program by Deepak Kumar Rout
% vssut Burla

clc;
clear all; 
close all;


I=imread('katrina.jpg');
I=rgb2gray(I);
I=imresize(I,[64 64],'bilinear');
[N N]=size(I)
imshow(I)
I=im2double(I);


sigma=input('Enter the value of sigma  ');
psi=input('Enter the value of psi   ');
gamma=input('Enter the value of gamma   ');
n1=input('Enter the number of lambda you want to take   ');
lambda=input('Enter the different values of lambda  ');
n2=input('Enter the number of theta you want to take  ');
theta=input('Enter the different values of theta');


for i=1:n1
    l=lambda(i);
    figure
    for j=1:n2
        t=theta(j);
        g1=gabor_fn(sigma,t,l,psi,gamma);
        display('value of lambda');display(l);
        display('value of theta ');display(t);
        display('output of gabor filter will be');display(g1);
%         figure
        subplot(1,n2,j);
        GT=conv2(I,double(g1),'same')
        imshow(GT);
    end
end 

