function [ data_idxs centroids ] = kmeansK( data_vecs, k )
%KMEANSK Performs K-means clustering given a list of feature vectors and k
%   The argument k indicates the number of clusters you want the data to be
%   divided into. data_vecs (N*R) is the set of R dimensional feature 
%   vectors for N data points. Each row in data_vecs gives the R 
%   dimensional vector for a single data point. Each column in data_vecs 
%   refers to values for a particular feature vector for all the N data 
%   points. The output data_idxs is a N*1 vector of integers telling which 
%   cluster number a particular data point belongs to. It also outputs 
%   centroids which is a k*R matrix, where each rows gives the vector for 
%   the cluster center. If we want to segment a color image i into 5 
%   clusters using spacial and color information, we can use this function 
%   as follows:
%
%
%   Example:
%       r = i(:,:,1);
%       g = i(:,:,2);
%       b = i(:,:,3);
%       [c r] = meshgrid(1:size(i,1), 1:size(i,2));
%       data_vecs = [r(:) g(:) b(:) r(:) c(:)];
%       [ data_idxs centroids ] = kmeansK( data_vecs, k );
%       d = reshape(data_idxs, size(i,1), size(i,2));
%       imagesc(d);
%
%
%   @author: Ahmad Humayun
%   @email: ahmad.humyn@gmail.com
%   @date: June 2010


    data_vecs = double(data_vecs);
    
    % generate initial centroids based on max and min values
    min_vec_vals = min(data_vecs,[],1);
    max_vec_vals = max(data_vecs,[],1);
    
    % initialize the cluster centers
    centroids = arrayfun(@(i) linspace(min_vec_vals(i), max_vec_vals(i), k)', 1:size(data_vecs,2), 'UniformOutput', false);
    centroids = cell2mat(centroids);
    prv_centroids = centroids + 1;
    
    % iterate until the cluster centers stop changing
    while any(any(prv_centroids ~= centroids))
        % store prv for checking when to end iterating kmeans
        prv_centroids = centroids;

        % find the distance from the means
        dists = zeros(size(data_vecs,1),k);
        for k_idx = 1:k
            temp = data_vecs - repmat(centroids(k_idx,:), [size(data_vecs,1) 1]);
            dists(:,k_idx) = sum(temp.^2,2);
        end
        
        % find the centroid which is closest to the data
        [~, data_idxs] = min(dists,[],2);
        temp_centroids = arrayfun( @(x) mean(data_vecs(data_idxs == x,:),1), 1:k, 'UniformOutput', false )';
        change_centroids = ~cellfun( @(x) any(isnan(x)), temp_centroids );
        
        % only change the centroids which are valid
        centroids(change_centroids,:) = cell2mat(temp_centroids(change_centroids));
    end
end