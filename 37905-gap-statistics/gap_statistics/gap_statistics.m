%%%%%%%%%%%%%%%%%%%%%%%%%
%
% A.Crimi 22 August 2012 
%
% input: 
%       data: samples along the rows, each column has a different variable
%       num_clusters: vector containing the possible number of clusters
%       num_reference_bootstraps: the number of boostrap estimation for the
%       reference dispersion
%
% output:
%        optimal cluster number for the samples in data
%
%%%%%%%%%%%%%%%%%%%%%%%%

function [ opt_k, max_gap] = gap_statistics(data, num_clusters, num_reference_bootstraps, compactness_as_dispersion)

if(nargin<4)
    compactness_as_dispersion = 0;
end

% Calculate actual dispersion
% Assuming that the k-means algorithm is converging properly
actual_dispersions = calculate_dispersion(data, num_clusters, compactness_as_dispersion);

% Calculate reference dispersion
%The reference dispersion is generally not well estimated for less than 2000 bootstrap iterations
[m_ref_dispersions std_reference_dispersion] = compute_reference_dispersion(data, num_clusters, num_reference_bootstraps, compactness_as_dispersion);
 
% Calculate gaps
gaps = abs(m_ref_dispersions - actual_dispersions);

% Check for Nan and Inf
if(sum(isnan(gaps) |  sum(isinf(gaps))) |  sum(isnan(std_reference_dispersion) |  sum(isinf(std_reference_dispersion))))
  disp('Warning: There is a NaN or Inf among the results');  
end

% Calculate Maximum gap
% This is the traditional way assuming  that the data are not noisy
[val max_index ] = max(gaps) ;
max_gap = num_clusters(max_index);

% Find the smallest k such that Gap(k) > Gap(k+1) -  std_{k+1}
%gaps = mean(n_gaps);
%std_reference_dispersion = std(gaps,1,1);
dif_std = abs( gaps - (sqrt(1 + 1/num_reference_bootstraps) * std_reference_dispersion ) );

[xpos ypos ] =  find( ( gaps(1:end-1) - dif_std(2:end)) > 0 ); %Note: Matlab returns the first min
 
if(isempty(xpos))
    xpos = max(num_clusters);
end
% Take only the first
opt_k = num_clusters(xpos(1));

str = sprintf('The max gap is for %d cluster/s', max_gap);
disp(str);
str = sprintf('The largest gap change is for %d cluster/s. Consider this value for noisy data', opt_k);
disp(str);

%figure; errorbar( num_clusters, gaps,  std_reference_dispersion);
%xlabel('Number of Clusters')
%ylabel('Gaps')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate dispersions
function dispersions = calculate_dispersion(test_data, num_clusters, compactness_as_dispersion)
dispersions = zeros(length(num_clusters),1); % W in the Tibshirani paper
[n_samples var_dim] = size(test_data);

for kk = 1 : length(num_clusters)    
    if(kk == 1) %K-means do not work for the only 1 cluster case
        cluster_mean = mean(test_data);
        if(compactness_as_dispersion)  
            D  = sum( sum( squareform(pdist(test_data  )))) / (2 * n_samples ) ; %Already normalized for 2n
        else
            D = sum(  (sum( test_data - repmat(cluster_mean,n_samples,1) ).^2) )/ (2 * n_samples ); 
        end
        dispersions(kk) =  log( D );  
    else
        
        ids = kmeans( test_data, num_clusters(kk) , 'Replicates', 5 ); %Warning k-means performs random initialization
  
        for  jj = 1 : kk
              if(compactness_as_dispersion)
                 D(jj) = sum( sum( squareform(pdist(test_data( find(ids == kk) ,:) )))) / (2 * length( find(ids == kk))); %Already normalized for 2n
              else
                 cluster_mean = mean(test_data( find(ids == kk)));
                 [n_samples_c var_dim] = size(test_data( find(ids == kk)));
                 D(jj) = sum( (test_data( find(ids == kk)) - repmat(cluster_mean,n_samples_c,1) ).^2)/ (2 * n_samples_c );%Already normalized for 2n
              end 
        end
        dispersions(kk) = log(sum(D));
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate reference dispersion
% For an appropriate reference distribution (in this case, uniform points in the same range as `data`), simulate the mean and standard deviation of the dispersion.
function [m_reference_dispersion std_reference_dispersion] = compute_reference_dispersion(reference_data, num_clusters, num_iteration, compactness_as_dispersion)
     
         reference_dispersion = zeros( length(num_clusters),  num_iteration);

         for zz = 1 : num_iteration
             generated_data = generate_uniform_points(reference_data);
             reference_dispersion(:,zz) = calculate_dispersion(generated_data, num_clusters, compactness_as_dispersion);
         end 
 
         m_reference_dispersion = mean(reference_dispersion,2);
         std_reference_dispersion = std(reference_dispersion, 0, 2);
end

% Generate artificial points similar to the original dataset
function uniform_points = generate_uniform_points(data_points)       
         [n_points var_dim] = size(data_points); 
          
         uniform_points = unifrnd(min(min(data_points)),max(max(data_points)),n_points,var_dim);

         %mu = mean(data_points);
         %Sigma = cov(data_points);
         % For each dimension, generate datapoints according to the mean and covariance obtained 
         %uniform_points = mvnrnd(mu,Sigma,n_points) ;
         %randi([mins maxs], num_datapoints, dim);
end
