% P. Perona and W. T. Freeman, "A factorization approach to grouping",
% In H. Burkardt and B. Neumann, editors, Proc ECCV, pages 655-670, 1998.

% Yair Weiss, "Segmentation Using Eigenvectors: A Unifying View", UC
% Berkeley.

% Asad Ali
% GIK Institute of Engineering Sciences & Technology, Pakistan
% Email: asad_82@yahoo.com

% CONCEPT: Clustering algorithm based on thresholding of the first eigenvector of
% the affinity matrix
clear all;
close all;

THRESHOLD = 0.28; % change the threshold depending on the data.
% generate the data
data = GenerateData(1);
% break the block matrix structure
data = data(3:14,:);
figure,plot(data(:,1), data(:,2),'r+'),title('Original Data Points'); grid on;shg

affinity = CalculateAffinity(data);
figure,imshow(affinity,[]),title('Affinity Matrix')

[eigVectors,eigValues] = eig(affinity);

% first eigenvector is the one which has the highest eigenvalue
sz = size(eigVectors);
firstEig = eigVectors(:,sz(1,2));

% plot the eigen vector corresponding to the largest eigen value
[xx1,yy1,val1] = find(firstEig > THRESHOLD);
[xx2,yy2,val2] = find(firstEig <= THRESHOLD);
figure,
hold on;
plot(data(xx1,1),data(xx1,2),'g*')
plot(data(xx2,1),data(xx2,2),'b*')
hold off;
title('Clustering Results after thresholding the First Eigenvector');
grid on;shg
