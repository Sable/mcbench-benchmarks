function [Yiv, Eiv] = indivfc(X, y, m, rol, lag, distr)
%INDIVFC: Make individual forecasts
%   [YIV, EIV] = INDIVFC(X, y, m, ...) fits multiple individual generalized 
%   linear models per factor using the predictors stored in matrix X and 
%   response Y with the in-sample ending at M by the means of the GLMFIT 
%   function, and makes multiple one-step ahead forecasts on the base of 
%   Y(t) = c1 + c2 X(t-lag,j). 
%
%   'X' is a matrix with rows corresponding to observations, and columns to
%   predictor variables. GLMFIT automatically includes a constant term
%   in the model (do not enter a column of ones directly into 'X').
%   'y' is a vector of response values. 'm' refers to the start of the
%   hold-out period and is assumed to be sufficiently larger than 1, to 
%   avoid for unnecessary large estimation errors.
%
%   [YIV, EIV] = INDIVFC(X, Y, M, q0, 'val1', 'val2', 'val3') allows you to 
%   specify additional parameter values to control the model fit and 
%   forecasts. Parameter values are:
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
%   [YIV, EIV] = INDIVFC(...) returns the 'n' by 'k' matrices:
%       'Yiv'      individual forecasts of 'y' on the base of the
%                   factors 1,...,k
%       'Eiv'      the realized prediction errors

%  Semin Ibisevic (2011)
%  $Date: 6/10/2011 19:31:03 $

if nargin < 3
    error('stats:indivfc:TooFewInputs','At least three arguments are required');
end

if nargin < 4 || isempty(rol), rol = 0; end
if nargin < 5 || isempty(lag), lag = 1; end
if nargin < 6 || isempty(distr), distr = 'normal'; end

if lag < 0 
    error('stats:indivfc:InvalidInput','Lag cannot be negative');
end

if rol > m 
    error('stats:indivfc:InvalidInput','m should be always larger than rol');
end

% Initialization
n = size(y,1);
k = size(X,2);
if size(X,1) ~= size(y,1)
    error('stats:indivfc:Dimension','The dimensions of X and y do not agree');
end
Yiv =  zeros(n,k);
Eiv = zeros(n,k);

iter = rol+1;
for t=m:n
    % forecasts are made individually per predictor j
    for j=1:k
        Xtemp = X( iter:t-lag , j);
        Ytemp = y( iter+lag:t );
        
        b = glmfit(Xtemp,Ytemp,distr);
        
        Yiv(t+1,j) = [1, X(t, j)]*b;
        
        if t < n
        Eiv(t+1,j) = y(t+1) - Yiv(t+1,j);
        end
        
    end
    
    % in case of a rolling window
    if rol > 0
        iter = iter+1;
    end
end