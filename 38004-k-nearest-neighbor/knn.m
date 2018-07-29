%=====================================================================
% Filename:      knn.m
%                
% Version:       0.9.0 (testing)
% Author:        LI, Wei <kuantkid<at>gmail.com>
%                
% Modified at:   Mon Sep  3 11:59:05 2012
% Created at:    Mon Sep  3 11:47:55 2012
%                
% Description:   Kmeans with 
%                    1. parallel(TODO)/chunking distance calculatation
%                       for large dataset
%                    2. simple posterior estimation using distance
%                    3. class weight assignment
%                Input:
%                    train: n_features x n_data
%                  trlabel: training labels, should be 1 - n_label
%                    probe: n_features x n_data
%                        k: number of k_nearest neighbor
%                      opt: options
%                         cache_num: number of chunks to be used
%                            trans : transform the score from squared distance using any rbf fuction, standard knn can have trans = @(x) ones(size(x));
%                            pad   : using the pad+ nearest neighbor, useful when doing cross validation
%                          
% Copyright Wei LI (@kuantkid) Released Under Create Common BY-SA
%=====================================================================
function [label, voting, prob_est] = knn(train, trlabel ,probe, k ,opt)
% make sure that label is 1 - numel(unique(trlabel))
if ~exist('opt','var')
    opt = struct();
end

if ~isfield(opt,'tran')
    opt.tran = @(x, sigma) exp(-x ./ (2*sigma) );
end

if ~isfield(opt,'cache_num')
    opt.cache_num = 1;
end

if ~isfield(opt,'pad')
    opt.pad = 0;
end

% probe may be too big
n_tr = size(train, 2);
dim  = size(train, 1);
n_pr = size(probe, 2);

u_label = unique(trlabel);
n_label = length(u_label);

if ~isfield(opt,'labelweight')
    opt.labelweight = ones(1, n_label);
end
opt.labelweight = opt.labelweight(:)';

ll = sparse(1:n_tr, trlabel, 1, n_tr, n_label, n_tr);

k_group   = kgroup(1:n_pr, opt.cache_num);

result = zeros(n_pr, n_label);
for i = 1:opt.cache_num
    fprintf('Batch %d of %d', i, opt.cache_num);
    % calculate the training set
    % TIP: we can use the distance to get the ranking then apply the exp
    M = (sqdist(train, probe(:,k_group{i})));
    [D,M] = sort(M,1,'ascend');
    % construct a ll matrix, by the labels from the first 
    M = (M((1:k) + opt.pad,:));
    D = opt.tran(D((1:k) + opt.pad,:), median(M(:)));
  
    % convert M into labels
    M = trlabel(M(:));
    % tVoter = full(sparse(repmat(k_group{i}(:)', [1 k]) ,M(:), D(:) , k * numel(k_group{i}) ,n_label));
    tVoter = full(sparse(1: k * numel(k_group{i}) ,M(:), D(:) , k * numel(k_group{i}) ,n_label));
    % fold the k-trials into the first dimension, the n_probe into the
    % second and n_label into the third
    tVoter = reshape(tVoter,[k numel(k_group{i}) n_label]);
    
    % using the label weight.
     tSize = size(tVoter);
    tVoter = reshape(bsxfun(@times,...
                            reshape(tVoter,[prod(tSize(1:end-1)) tSize(end)]),...
                            opt.labelweight),...
                    tSize);
    
    tVoter = squeeze(sum(tVoter, 1));
    
    % pack into the result
    result(k_group{i},:) = tVoter;

    % memory clear
    clear tVoter M D
end

% calculate the label, largest affinity
% result should be a n_probe x n_label matrix, distance is transformed
[~,l] = max(result,[],2);
label = u_label(l(:,1));

if(nargout >= 2)
    voting = result;
end

% calculate probability output
if(nargout >= 3)
    prob_est = bsxfun(@times, voting,1./sum(voting,2));
end

end

function [M] = sqdist(X1, X2)
    M = bsxfun(@plus, sum(X1 .* X1, 1)', (-2) * X1' * X2);        
    M = bsxfun(@plus, sum(X2 .* X2, 1), M);        
end

function [grp] = kgroup(idx, k, opt)
% make the indexes into K-Disjoint Groups
if ~exist('opt','var')
    opt.rand = false;
end

if isfield(opt,'rand')
    opt.rand = false;
end

n = length(idx);

if(opt.rand)
    ridx = randperm(length(idx));
    idx = idx(ridx);
end

% the last one is the largest.
grp = cell(1,k);
gnum = floor(n / k);

% grp indexes
for i = 1:(k-1)
    grp{i} = idx( (1 + (i-1) * gnum) : i * gnum);
end

% the kth group
grp{k} = idx((gnum * (k-1)+1): n);
end
