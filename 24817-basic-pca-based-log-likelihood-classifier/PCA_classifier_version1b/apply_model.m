function [distanceL,distanceG,LogLikelihood]=apply_model(T,Lmean,Gmean,Cgppca,invCgppca,Vtot)
% This function Apply_Model uses the matrices and means from train_model.m
% to calculate the mahalanobis distance to global and local feature
% training data set, which are combined to a log Likelihood ratio.
%
% [distanceL,distanceG,LogLikelihood]=apply_model(T,Lmean,Gmean,Cgppca, invCgppca,Vtot)
%
% inputs,
%   T: Matrix with all feature vectors from the test data,  first 
%           feature vector T(:,1)
%   G: Matrix with all feature vectors from the global (not) training data
% inputs (from train_model.m)
%   Lmean : The mean of the local feature vectors
%   Gmean : The mean of the global feature vectors
%   Cgppca : Covariance matrix after 3 PCA steps
%   invCgppca : Inverse Covariance matrix after 3 PCA steps
%   Vtot : The Rotation matrix of the 3 PCA steps% outputs,
%
% outputs,
%   distanceL : The distance to the local training data set
%   distanceG : The distance to the global training data set
%   LogLikelihood : The log likelihood of test feature vector to belong to 
%                   the local set.
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

distanceL=zeros(1,size(T,2));
distanceG=zeros(1,size(T,2));
for i=1:size(T,2)
    u=Vtot'*(T(:,i)-Gmean);
    v=Vtot'*(T(:,i)-Lmean);
    distanceG(i)=(u'*invCgppca*u);
    distanceL(i)=(v'*v);
end
offset=log(det(Cgppca));
LogLikelihood=0.5*(distanceG-distanceL)+0.5*offset;
