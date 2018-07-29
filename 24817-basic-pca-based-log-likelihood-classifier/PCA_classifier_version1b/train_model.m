function [Lmean,Gmean,Cgppca,invCgppca,Vtot]=train_model(L,G)
% This function Train_Model makes the PCA matrices and mean values
% from a set of training feature vectors, needed to perform
% maximum likelihood classification on a two class classifiaction problem
%
% [Lmean,Gmean,Cgppca,invCgppca,Vtot]=train_model(L,G)
%
% inputs,
%   L: Matrix with all feature vectors from the local (true) training data
%           first feature vector L(:,1)
%   G: Matrix with all feature vectors from the global (not) training data
%
% outputs,
%   Lmean : The mean of the local feature vectors
%   Gmean : The mean of the global feature vectors
%   Cgppca : Covariance matrix after 3 PCA steps
%   invCgppca : Inverse covariance matrix after 3 PCA steps
%   Vtot : The Rotation matrix of the 3 PCA steps
%
%  In the 3 PCA steps, the feature vectors are rotated in a way that 
%  the Mahalanobis distance to the local set can be deteremined by 
%  FeatureA'*FeatureA, and to the global set by FeatureA'*invCgppca*FeatureA.
%  FeatureA is the mean substracted and rotated FeatureVector of a certain
%  test (image/coordinate).
%
% Literature : Kroon, D.J. and van Oort, E.S.B. and Slump, C.H. "Multiple 
% Sclerosis Detection in Multispectral Magnetic Resonance Images with 
% Principal Components Analysis"
%
% Function is written by D.Kroon University of Twente (July 2009)

% Center feature examples by substracting the mean
Lmean=mean(L,2); 
Gmean=mean(G,2); 
Lcenterd=L-Lmean*ones(1,size(L,2));
Gcenterd=G-Gmean*ones(1,size(G,2));
clear L; clear G;

% Single Value Decomposition (PCA) of global "not" class
% obtaining eigenvectors and eigenvalues
[U,S] = svd(Gcenterd/sqrt(size(Gcenterd,2))); % svds
Geigenvalue=diag(S); Geigenvectors=U; clear V; clear U; clear S;

% Limit the number of eigenvectors (against image noise)
nev=find(cumsum(Geigenvalue./sum(Geigenvalue))>0.90); nev=nev(1);
Geigenvectors=Geigenvectors(:,1:nev);
% Geigenvalue=Geigenvalue(1:nev);

% Calculate the F rotated new features
Gcentrot=zeros([nev size(Gcenterd,2)]);
Lcentrot=zeros([nev size(Lcenterd,2)]);
for i=1:size(Gcenterd,2), Gcentrot(:,i)=Geigenvectors'*(Gcenterd(:,i)); end
for i=1:size(Lcenterd,2), Lcentrot(:,i)=Geigenvectors'*(Lcenterd(:,i)); end
clear Lcenterd; clear Gcenterd;

% Single Value Decomposition (PCA) of reduced local class
% obtaining eigenvectors and eigenvalues
[U,S] = svd(Lcentrot/sqrt(size(Lcentrot,2))); % svds
Leigenvalue=diag(S); Leigenvectors=U; clear V; clear U; clear S;

% Limit number of eigenvectors,
nev=find(cumsum(Leigenvalue./sum(Leigenvalue))>0.90); nev=nev(1);
Leigenvectors=Leigenvectors(:,1:nev);
Leigenvalue=Leigenvalue(1:nev);

% Normalize the eigenvectors
for i=1:nev, Leigenvectors(:,i)=Leigenvectors(:,i)/sqrt(Leigenvalue(i));  end

% Calculate the F rotated new features
Gcentrot2=zeros([nev size(Gcentrot,2)]);
Lcentrot2=zeros([nev size(Lcentrot,2)]);
for i=1:size(Gcentrot,2), Gcentrot2(:,i)=Leigenvectors'*(Gcentrot(:,i)); end
for i=1:size(Lcentrot,2), Lcentrot2(:,i)=Leigenvectors'*(Lcentrot(:,i)); end
clear Lcentrot; clear Gcentrot;

% Second Single Value Decomposition (PCA) of global "not" class
% obtaining eigenvectors and eigenvalues
[U,S] = svd(Gcentrot2/sqrt(size(Gcentrot2,2))); % svds
%G2eigenvalue=diag(S); 
G2eigenvectors=U; clear V; clear U; clear S;

% Calculate the F rotated new features
Gcentrot3=zeros([nev size(Gcentrot2,2)]);
Lcentrot3=zeros([nev size(Lcentrot2,2)]);
for i=1:size(Gcentrot2,2), Gcentrot3(:,i)=G2eigenvectors'*(Gcentrot2(:,i)); end
for i=1:size(Lcentrot2,2), Lcentrot3(:,i)=G2eigenvectors'*(Lcentrot2(:,i)); end
clear Fcentrot; clear Gcentrot;

% Total feature transformation
Vtot=(Geigenvectors*Leigenvectors*G2eigenvectors);

% The needed covariance matrix
Cgppca=cov(Gcentrot3');
invCgppca=inv(Cgppca);
