
function [cov_ewma,corr_ewma,vola_ewma] = ewma_covariance(data,lambda)

% calculates the RiskMetrics "Technical Document" (1996) exponentially 
% weighted covariance matrix (p.179), correlation and volatilities.
% 
% Input:
% data - needs to be in format T x k with T = # observations, k = # assets
% lambda = decay factor

[r,c]         = size(data);
data_mwb      = data-repmat(mean(data,1),r,1);
lambdavec     = lambda.^(0:1:r-1)';
data_tilde    = repmat(sqrt(lambdavec),1,c).*data_mwb;

cov_ewma      = 1/sum(lambdavec)*(data_tilde'*data_tilde);
corr_ewma     = zeros(c);
vola_ewma     = zeros(c,1);

for i = 1:c
    for j = 1:c
        corr_ewma(i,j) = cov_ewma(i,j)/sqrt(cov_ewma(i,i)*cov_ewma(j,j));
    end
    vola_ewma(i) = sqrt(cov_ewma(i,i));
end
