%%%%%%%%%%%%%%%%%%%%%%%%%
%
% A.Crimi 22 August 2012
%
%%%%% Test gap_statistics
%
% Reference reading :
% R. Tibshirani, G. Walther and T. Hastie 
% "Estimating the number of clusters in a dataset via the Gap statistic".
% Journal of the Royal Statistical Society, B, 63:411-423,2001.
%
%%%%%%%%%%%%%%%%%%%%%%%%%

function test_gap_statistics(test_datas)
 
num_clusters = [ 1 2 3 4 5 ];  
num_reference_bootstraps = 2000;  

% Artificial dataset 
test_datas = rand(100,2)*1;
test_data2 = rand(100,2)*1+10;
test_data3 = rand(100,2)*1+1000;
test_datas = cat(1,test_datas, test_data2); %Comment this to see that no clusters exist
test_datas = cat(1,test_datas, test_data3); %Comment this to see that no clusters exist


%Test different runs of k-means clustering
% iterations_test 
iter_test = 10;
opt_index = zeros(iter_test,1);
max_gap = zeros(iter_test,1);
% 1 for using compactness as the dispersion measure, instead of the distance from the mean 
compactness_as_dispersion = 0; 

for ii = 1 : iter_test
     [ opt_index(ii), max_gap(ii)] = gap_statistics(test_datas, num_clusters, num_reference_bootstraps, compactness_as_dispersion);
end

str = sprintf('The mean results over different iteration is %d', round(mean(opt_index)));
disp(str);
str = sprintf('The median results over different iteration is %d', median(opt_index));
disp(str);


