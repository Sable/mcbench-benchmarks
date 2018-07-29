function [means,Nmeans] = simple_kmeans(X,K,maxerr)

% function [medias,Nmedias] = simple_kmedias(X,K,maxerr)
%   Finds K prototypes representing the samples in data matrix X,
%   where each row of X represents a sample. 
%   Iterates until maximum norm difference between
%   prototypes found in successive iterations is < maxerr
%   
%   This script uses square Euclidean distance, 
%   but can be easily modified to use other metrics
%
% Output arguments
%   means: matrix with each row a cluster prototype
%   Nmeans: Number of samples in each cluster
%
% Example:
%   X = [randn(100,1) ;  2+randn(100,1)];
%   K = 2;
%   [means Nmeans] = simple_kmeans(X,K,0)
%
%   Mauricio Martinez-Garcia, 2003,2007

[Ndata, dims] = size(X);
dist = zeros(1,K);

% Initial prototype assignment (arbitrary)
for i=1:K-1
   means(i,:) = X(i,:);
end
means(K,:) = mean(X(K:Ndata,:));

cmp = 1 + maxerr;
while (cmp > maxerr)
   % Sums (class) and data counters (Nclass) initialization
   class = zeros(K,dims);
   Nclass = zeros(K,1);

   % Groups each elements to the nearest prototype
   for i=1:Ndata
      for j=1:K
         % Euclidean distance from data to each prototype
         dist(j) = norm(X(i,:)-means(j,:))^2;
      end
      % Find indices of minimum distance
      index_min = find(~(dist-min(dist)));
      % If there are multiple min distances, decide randomly
      index_min = index_min(ceil(length(index_min)*rand));
      class(index_min,:) = class(index_min,:) + X(i,:);
      Nclass(index_min) = Nclass(index_min) + 1;
   end
   for i=1:K
      class(i,:) = class(i,:) / Nclass(i);
   end

   % Compare results with previous iteration
   cmp = 0;
   for i=1:K
      cmp = norm(class(i,:)-means(i,:)); 
   end

   % Prototype update
   means = class;
end

Nmeans = Nclass;
