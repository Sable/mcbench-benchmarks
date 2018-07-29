function C = EstimateUnitNormalCorr(Y_X, exp_window_size, shrink_factor)
%C = EstimateUnitNormalCorr(Y_X, exp_window_size, shrink_factor)
%  Estimate the correlation matrix of a joint normal sample, where each
%  element is assumed to be unit normal. Each column of Y_F is a random
%  variable and each row is a sample. Exponential weighting is applied in
%  time, and RMT filtering is applied using the "PG" algorithm.
%
% To do!!:
%   - review implementation of exponential weighting and RMT
%   - add choice for rectangular averaging?
%   - add choice for other RMT schemes?
% Code by S. Gollamudi. This version December 2009. 


[T,N] = size(Y_X);
use_rmt_cleaning = 0;

%% Estimate sample correlation matrix with exponential averaging

% compute exponential weights
lambda = 2/exp_window_size;
exp_wts = (1-lambda).^(T-1:-1:0)*(lambda/(1-(1-lambda)^T));
m_exp_wts = repmat(exp_wts',1,N);

% compute the exponentially weighted sample mean
meanYX = sum(m_exp_wts.*Y_X, 1);
% remove mean from the time series Y_X
Y_X = Y_X - repmat(meanYX,T,1);

% compute the exponentially weighted standard deviation
stdYX = sqrt(sum(m_exp_wts.*(Y_X.^2), 1));

% compute the exponentially weighted correlation matrix
C = ((m_exp_wts.*Y_X)'*Y_X)./(stdYX'*stdYX);
diag_indx = 1:(N+1):(N*N);


%% Clean the correlation matrix estimate using Random Matrix Theory

if use_rmt_cleaning,

    % ratio of the effective series length and the number of variables
    Q = exp_window_size/N;

    % maximum random eigenvalue
    e_max = rmtEigenLim(Q,1);

    [eigVec,eigVal] = eig(C);
    [eigVal,Idx] = sort(diag(eigVal),'descend');
    eigVec=eigVec(:,Idx);
    % K is the # of non-random eigenvalues
    K=length(find(eigVal>e_max));
    % PG filter
    eigVal(K+1:end)=mean(eigVal(K+1:end));
    C = eigVec*diag(eigVal)*eigVec';
    % make the diagonal elements equal to one
    C(diag_indx) = 1;
    
end
 
%% Shrink to average correlation

% compute the average pairwise correlation coefficient
rho = (sum(sum(C)) - N)/(N*(N-1));
C_rho = rho*ones(N,N);
C_rho(diag_indx) = 1;

% shrink C towards C_rho
if nargin < 3, shrink_factor = 1/3; end
C = (1-shrink_factor)*C + shrink_factor*C_rho;
