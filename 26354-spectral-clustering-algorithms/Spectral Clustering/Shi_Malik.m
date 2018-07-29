% J. Shi and J. Malik,
% "Normalized Cuts and Image Segmentation",
% In Proc. IEEE Conf. Computer Vision and Pattern Recognition, 
% pages 731-737, 1997.

% Asad Ali
% GIK Institute of Engineering Sciences & Technology, Pakistan
% Email: asad_82@yahoo.com

% CONCEPT: Introduced the use of 2nd generalized eigenvector for clustering
clear all;
close all;

% generate the data
data = GenerateData(2);
figure,plot(data(:,1), data(:,2),'r+'),title('Original Data Points'); grid on;shg

affinity = CalculateAffinity(data);
figure,imshow(affinity,[]), title('Affinity Matrix');

% compute the degree matrix
for i=1:size(affinity,1)
    D(i,i) = sum(affinity(i,:));
end

% compute the unnormalized graph laplacian matrix
L = D - affinity; 

[eigVectors,eigValues] = eig(L);

% plot the eigen vector corresponding to the 2nd largest eigen value
figure,plot(eigVectors(:,2),'r*'),title('2nd Largest Eigenvector');

% threshold the eigen vectors
[xx1,yy1,val1] = find(eigVectors(:,2) > 0.15);
[xx2,yy2,val2] = find(eigVectors(:,2) > 0 & eigVectors(:,2) < 0.15);
[xx3,yy3,val3] = find(eigVectors(:,2) < 0);

figure,
hold on;
plot(data(xx1,1),data(xx1,2),'m*');
plot(data(xx2,1),data(xx2,2),'b*');
plot(data(xx3,1),data(xx3,2),'g*');
hold off;
title('Clustering Results using 2nd Generalized Eigen Vector');
grid on;shg
