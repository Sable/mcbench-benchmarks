function [Yp, Ep, coeff, score, latent] = pcafc(X, y, m, J, Zbin, rol, lag, distr)
%PCFAC: Make forecasts with the principal components
%   [Yp, Ep, ...] = PCAFC(X, Y, M, ...) makes forecasts by taking the 
%   principal components of X as predictors and y as the response variable.
%   The estimates of the coefficients are obtained through GLMFIT.
%
%   'X' is a matrix with rows corresponding to observations, and columns to
%   predictor variables. GLMFIT automatically includes a constant term
%   in the model (do not enter a column of ones directly into 'X').
%   'y' is a vector of response values. 'm' refers to the start of the
%   hold-out period and is assumed to be sufficiently larger than 1, to 
%   avoid for unnecessary large estimation errors.
%
%   [Yp, Ep, ...] = PCAFC(X, Y, M, 'val1', 'val2', 'val3', 'val4', ...
%   'val5', 'val6') allows you to to specify additional parameter values to
%   control the model fit and forecasts. Parameter values are:
% 
%       'J' - the number of principal components to include in the pooled 
%       regression. J is set equal to 1 as default.
%
%       'Zbin' - defines whether de principal components should be obtained 
%       through taking the eigenvectors of the correlation matrix of X 
%       accessed through 'Zbin' = 'corr', or on the covariance matrix, set 
%       'Zbin' equal to 'cov'. 
%
%       'rol' - length of the rolling window. In case 'rol' is set equal to 
%       zero, the corresponding individual forecasts and pooled regression 
%       are made through an expanding window framework. Important, it is
%       obligated to set rol > m and it is advisably to set rol >> m.
%
%       'lag' - the number of lags in the regression Y(t) = c1 +
%       c2*X(t-lag)
%
%       'distr' -   Acceptable values for DISTR are 'normal', 'binomial', 
%       'poisson', 'gamma', and 'inverse gaussian'.  The distribution is 
%       fit using the canonical link corresponding to DISTR. See also the
%       GLMFIT function for further explanation.
%
%   GLMFIT treats NaNs in 'X' and 'y' as missing data, and removes the
%   corresponding observations.
%
%   [YIV, EIV, ...] = PCAFC(...) returns the n-by-1 vectors:
%       'Yp'      the forecasts on the base of the J principal components
%       of the explanatory factors.
%       'Ep'      the realized prediction errors
%   
%   [YIV, EIV, COEFF] = PCAFC(...) returns the latest principal component 
%   coefficients per time t, also known as loadings. 
%   Rows of X correspond to observations, columns to variables. 
%   COEFF is a p-by-p-by-t matrix, each column containing coefficients 
%   for one principal component. The columns are in order of decreasing 
%   component variance.
%
%   [YIV, EIV, COEFF, SCORE] = PCAFC(...) returns SCORE, the latest (t)
%   principal component scores; that is, the representation of X in the 
%   principal component space. Rows of SCORE correspond to the components
%   at every point time t.
%
%   [YIV, EIV, COEFF, SCORE, LATENT] = PCAFC(...) returns LATENT, a vector
%   containing the eigenvalues of the covariance matrix of X at every point 
%   of the time t.

%  Semin Ibisevic (2011)
%  $Date: 6/10/2011 20:22:34 $

if nargin < 3
    error('stats:indivfc:TooFewInputs','At least three arguments are required');
end

if nargin < 4 || isempty(J), J = 1; end
if nargin < 5 || isempty(Zbin), Zbin = 'corr'; end
if nargin < 6 || isempty(rol), rol = 0; end
if nargin < 7 || isempty(lag), lag = 1; end
if nargin < 8 || isempty(distr), distr = 'normal'; end

if lag < 0
    error('lag:indivfc:InvalidInput','Lag cannot be negative');
end

if rol > m
    error('rol:indivfc:InvalidInput','m should be always larger than rol');
end


% Initialization
n = size(y,1);
k = size(X,2);
if size(X,1) ~= size(y,1)
    error('y:indivfc:Dimension','The dimensions of X and y do not agree');
end

if isequal(Zbin,'corr') || isequal(Zbin,'cov')
    % correctly specified
else
    error('Zbin:combinefc:InvalidInput','Zbin can be only applied on cov or corr');
end

% retrieve the dynamic pca's
coeff = zeros(k,k,n);
score = zeros(n,J);
latent = zeros(n,k);

iter = 1;
for t = 1:n
    Xtemp = X( iter:t , :);
    switch Zbin
        case 'corr'
            [coeffAll,scoreAll,latentAll] = princomp(zscore(Xtemp));
        case 'cov'
            [coeffAll,scoreAll,latentAll] = princomp(Xtemp);
    end
    coeff(:,:,t) = coeffAll;
    score(t,1:J) = scoreAll(t,1:J);
    latent(t,:) = latentAll;
    
    % in case of a rolling window
    if rol > 0
        iter = iter+1;
    end
    
end

% get the individual forecasts
Yp = zeros(n,1);
Ep = zeros(n,1);
iter = rol+1;
for t=m:n
        Xtemp = score( iter:t-lag , :);
        Ytemp = y( iter+lag:t );
        
        b = glmfit(Xtemp,Ytemp,distr);
        
        Yp(t+1) = [1, score(t,:)]*b;
        
        if t < n
            Ep(t+1) = y(t+1) - Yp(t+1);
        end
    
    % in case of a rolling window
    if rol > 0
        iter = iter+1;
    end
end
