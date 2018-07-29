function [eigvector] = FNPAQR(data, class,options)
% Fuzzy Neighbourhood Preserving Analysis with QR-Decomposition
%
%              [eigvector] = OFNDA(data, class, options);
%
%              inputs
%              ======
%              data: feature matrix (nSmp x nFea)
%                    nSmp: no. of smaples.
%                    nFea: no. of features
%              class: class label of training data
%              options: structure
%                     options.ReducedDim: no. of extracted features (defined by user, but usually c - 1, with c being the number of classes)
%
%              Output
%              ======
%              eigvector: simply the projection matrix
%
%              Note: to get the new data with reduced dimensionality
%              just multiply data by eigvector, i.e.,
%              Newdata = data x eigvector
%
%              Written By: Rami Khushaba, PhD (UTS)
%              This is a simplified version with QR-Decomposition
%
% if you use this code, then kindly cite either of the following papers
%
% [1] R. N. Khushaba, S. Kodagoa, Dikai Liu, and G. Dissanayake, "Electromyogram (data) based Fingers Movement Recognition Using Neighborhood Preserving Analysis with QR-Decomposition", 
% Accepted, ISSNIP 2011 
% [2] R. N. Khushaba, A. Al-Ani, and A. Al-Jumaily, "Orthogonal Fuzzy Neighborhood Discriminant Analysis for Multifunction Myoelectric Hand Control", IEEE Transaction on Biomedical Engineering, vol. 57, no. 6, pp. 1410-1419, 2010.
%
% Updated on Feb 2012 for faster implementation by Dr. Rami Khusbaba
% 
[nSmp,nFea] = size(data);
nClass = max(class);
sampleMean = mean(data,1);
data = (data - repmat(sampleMean,nSmp,1));
center = MeanClust([data class]);
center = center(:,1:end-1);
expo=1.75;
distA = pdist2(center, data,'seuclidean');               % fill the distance matrix
distA = distA./repmat(max(distA,[],2),1,size(distA,2));
tmp = exp(.1251*distA).^(-2/(expo-1));
u = tmp./(ones(nClass, 1)*sum(tmp));
nc = nClass;
NB=0;
NBB =zeros(1,nc);
O2 = (zeros(nFea,nFea));
HD = data'; 
[Q, R] = qr(HD,0);
rd = rank(HD);
Q1 = Q(:,1:rd);
R = R(1:rd, :);
B = R * R';
Y = zeros(nFea,nClass);
for i= 1:nClass
    x = class==i;
    umf = sum(u(i,x).^2); 
    NBB(i) = umf;
    NB=NB+umf;
    O2 = O2+data(x,:)'*((u(i,x)'*u(i,x))./umf)*data(x,:);
    XX=((u(i,x))');
    Y(:,i) = data(x,:)'*XX./umf;
end
clear umf U U1 U2 u x1 x2 x XX
alpha = 0.01;
A = alpha*Q1'*(Y*Y')*Q1+ (1-alpha)*Q1'*(O2)*Q1;
A = max(A,A');
B = max(B,B');
option = struct('disp',0);
[V, D] = eigs(A,B,min(options.ReducedDim,rank(A)),'la',option);
[~,Dindx] = sort(max(D),'descend');
V=V(:,Dindx);
eigvector = Q1*V(:,1:min(options.ReducedDim,size(V,2)));


function center = MeanClust(data)
M = max(data(:,end));
center =zeros(M,size(data,2));
for i = 1:M
    classs = data(data(:,end)==i, :);
    if size(classs,1)>1
        center(i,:) =  mean(classs);
    else
        center(i,:) =  (classs);
    end
end

