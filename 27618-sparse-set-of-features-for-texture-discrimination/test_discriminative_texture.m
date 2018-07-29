close all;
% function F = discriminative_texture_feature(I_TEXT,theta,verbose,colored,include_intensity,tau_diff,steps_diff,sigma_diff)

Z = imread('zebra.bmp');
figure; imagesc(Z); set(gcf,'Name','original image');
% Z0 = discriminative_texture_feature(double(Z),6,[1 2],0,0,1,500,0); % 

Z1 = discriminative_texture_feature(double(Z),0,[1 2],0,1,1,500,0); % this takes a lot of time!, compare to p 64 of Thomas Brox's Phd Thesis
Z2 = discriminative_texture_feature(double(Z));% this is a rasonable approximation(depending on the application) to the previous one while being much faster

F = imread('frog.bmp');
figure; imagesc(F); set(gcf,'Name','original image');
% F0 = discriminative_texture_feature(double(F),6,[1 2],0,0,1,500,0); % 
F1 = discriminative_texture_feature(double(F),0,[1 2],0,1,1,1000,0); % this takes a lot of time!, compare to p 65 of Thomas Brox's Phd Thesis

F2 = discriminative_texture_feature(double(F),2,[2],0,1,10,100,0.5); % this is a rasonable approximation(depending on the application to the previous one while being much faster

[sy sx d] = size(Z);
figure;colormap gray;
subplot(2,3,1); imagesc(Z); title('original image');
for i = 1 :5, subplot(2,3,i+1); imagesc(reshape(Z1(i,:),[sy sx])); title(sprintf('F%d',i)); end