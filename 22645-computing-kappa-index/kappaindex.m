function [kappa] = kappaindex(X,G,N)
%  USAGE kappa=kappaindex(X,G,N)
% 
%  Computing Kappa Index for Clustering Agreement by Hossein Mobahi
% 
% X is a vector of length M (number of data samples).
%   Each entry of X is associated with the cluster index for that sample
% G is a vector in the same format of X belonging to ground truth indecies
%   or a secondary clustering
% N is the number of clusters
%
% This measure only works when X and G have the same number of clusters
% In addition, the set of indecies must be integers from one through
% the number of clusters.
% However, they might be equivalent through a permutation of indecies
%
% Example:
% >> X=[1 1 2 2 3 3]; G=[2 2 1 1 3 3]; kappaindex(X,G,3)
% ans = 1
% >> X=[1 1 2 2 4 4 3]; G=[4 2 2 2 1 1 3]; kappaindex(X,G,4)
% ans = 0.8056
%
%

% Check all permutations of cluster indecies
% And pick the one with maximal agreement

P=perms(1:N);

maxn=-inf;
for i=1:size(P,1)
 n=0;
 for j=1:length(X)
  if G(j)==P(i,X(j))
   n=n+1;
  end
 end
 if n>maxn
  maxn=n;
  maxi=i;
 end
end

% Build matrix
A=zeros(N,N);
for j=1:length(X)
  x=P(maxi,X(j));
  g=G(j);
  A(x,g)=A(x,g)+1;
end

% Compute the kappa index
t=0;
for i=1:N
 t=t+sum(A(i,:))*sum(A(:,i));
end
kappa=(length(X)*trace(A)-t)/(length(X)*length(X)-t);

