%=====================================================================
% Filename:      kmeans.m
%                
% Version:       1.0.0
% Author:        LI, Wei <kuantkid<at>gmail.com>
% Modified at:   Tue Aug 28 13:18:47 2012
% Created at:    Tue Aug 28 12:32:37 2012
%                
% Description:   
%                <Input> :
%                      D : nFeature x nData data matrix
%                      k : number of means
%                maxIter : maximum iteration
%
%               <Output> :
%                  label : cluster assignment
%                  means : means of each cluster
% Acknowledgement:
%               Inspired by Mo Chen's Kmeans on Matlab Central
% Copyright Wei LI (@kuantkid) Released Under Create Common BY-SA
%=====================================================================
function [label, means] = kmeans(D, k, maxIter)
    if(nargin < 3)
        maxIter = 1e10;
    end
    [dim n] = size(D);
    label = ceil(rand(1, dn(D)) * k);
    means = D(:,randi([1 n],[1 k]));
    last  = 0;
    [~, dd] = meshgrid(label, 1:dim);
    iter = 0;
    while ( any(last ~= label) && iter < maxIter) 
        last = label;iter = iter + 1;
        % calculate distance, update label
        [~,label] = max(bsxfun(@minus,means'*D,dot(means,means,1)'/2),[],1);
        % remove empty label
        [u,~,label] = unique(label);k = numel(u);
        % update means
        ll = repmat(label,[dim 1]);
        means = accumarray([dd(:) ll(:)], D(:), [dim k] ,@mean);
    end
end