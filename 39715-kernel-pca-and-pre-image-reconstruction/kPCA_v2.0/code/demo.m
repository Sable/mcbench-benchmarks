%%  This is a demo showing how to use this toolbox

%   Copyright by Quan Wang, 2011/05/10
%   Please cite: Quan Wang. Kernel Principal Component Analysis and its 
%   Applications in Face Recognition and Active Shape Models. 
%   arXiv:1207.3538 [cs.CV], 2012. 

clear;clc;close all;

load data.mat;
d=2;

%% standard PCA
disp('Performing standard PCA...');
Y1=PCA(data,d);
figure;hold on;
plot(Y1(1:2:end,1),Y1(1:2:end,2),'b*');
plot(Y1(2:2:end,1),Y1(2:2:end,2),'ro');
title('standard PCA');

%% kernel PCA
disp('Performing Gaussian kernel PCA...');
[Y2, eigVector, para]=kPCA(data,d,'gaussian',[]);
figure;hold on;
plot(Y2(1:2:end,1),Y2(1:2:end,2),'b*');
plot(Y2(2:2:end,1),Y2(2:2:end,2),'ro');
title('Gaussian kernel PCA');

%% pre-image reconstruction
disp('Performing kPCA pre-image reconstruction...');
PI=zeros(size(data)); % pre-image
for i=1:size(data,1)
    PI(i,:)=kPCA_PreImage(Y2(i,:)',eigVector,data,para)';
end

figure;hold on;
plot3(PI(1:2:end,1),PI(1:2:end,2),PI(1:2:end,3),'b*');
plot3(PI(2:2:end,1),PI(2:2:end,2),PI(2:2:end,3),'ro');
title('Reconstructed pre-images of Gaussian kPCA');