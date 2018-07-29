% Copyright (C) 2013 Quan Wang <wangq10@rpi.edu>, 
% Signal Analysis and Machine Perception Laboratory, 
% Department of Electrical, Computer, and Systems Engineering, 
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA
% 
% You are free to use this software for academic purposes if you cite our paper: 
% Quan Wang and Kim L. Boyer. 
% Feature Learning by Multidimensional Scaling and its Applications in Object Recognition.
% 2013 26th SIBGRAPI Conference on Graphics, Patterns and Images (Sibgrapi). IEEE, 2013.
% 
% For commercial use, please contact the authors. 


% This is a demo, showing how to use this MDS encoder toolkit.
% In this demo, we generate 3-d points in three clusters and measure 
% interpoint distances, and then embed these 3-d points into 2-d space. 
% Next we use k-means to cluster resulting 2-d points, and see whether
% clusters are preserved when reducing from 3-d to 2-d. 

clear;clc;close all;

%% data preparation

N1=100; % number of points for training
N2=100; % number of points to be encoded
N=N1+N2; % total number of points

X0=zeros(N,3); % 3-d coordinates of points
y0=zeros(N,1); % ground truth labels

for i=1:N
    % randomly decide the ground truth label
    y0(i)=mod(round(rand(1)*100),3)+1; 
    
    % generate points around the three centers
    if y0(i)==1
        X0(i,:)=[1 0 0]; % cluster center for label 1
    elseif y0(i)==2
        X0(i,:)=[0 1 0]; % cluster center for label 2
    else
        X0(i,:)=[0 0 1]; % cluster center for label 3
    end
    
    X0(i,:)=X0(i,:)+randn(1,3)/3; % add noise
end

% generate distance matrix Dist
Dist=zeros(N,N);
for i=1:N-1
    for j=i:N
        Dist(i,j)=norm(X0(i,:)-X0(j,:));
    end
end
Dist=Dist+Dist';

%% MDS training and encoding, and clustering encoded points

% distance matrix of training data
Dist_training=Dist(1:N1,1:N1); 

% distance matrix from training set to encoding set
Dist_encoding=Dist(1:N1,N1+1:end); 


d=2; % dimensionality of target space
K=3; % number of clusters

fprintf('Start training:\n');
[X1, total_cost]=MDS_training(Dist_training,d,10,0,1);

fprintf('Start encoding:\n');
X2=MDS_encoding(X1,Dist_encoding,1);

[y2, C2] = kmeans(X2,K);

%% evaluation

CM=zeros(K,K); % confusion matrix
y02=y0(N1+1:end); % ground truth labels for encoded points only
NN(1)=sum(y02==1);
NN(2)=sum(y02==2);
NN(3)=sum(y02==3);

for i=1:K
    for j=1:K
        CM(i,j)=sum(y02==i&y2==j)/NN(i);
    end
end
CM=confusion_matrix_reorder(CM); % reorder
draw_matrix(CM);

figure;
plot(total_cost,'-b^','LineWidth',2);
title('raw stress in each training iteration');
xlabel('iteration');
ylabel('raw stress');

