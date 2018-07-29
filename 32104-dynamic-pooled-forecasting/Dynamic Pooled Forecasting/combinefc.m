function [Yc, Ec] = combinefc(y, Yiv, type, theta, q0)
%COMBINEFC: Combine the individual forecasts
%   [Yc, Ec] = combinefc(y, Yiv, ... ) combines the individual forecasts
%   YIV through the selected methods through simple averaging schemes or a
%   weighted discounting function.
%
%   'y' is the vector with the true (actual) values of the dependent
%   variables. 'Yiv' is the n*k matrix of the individual forecasts.
%
%   [Yc, Ec] = combinefc(y, Yiv, 'val1', 'val2', 'val3' ) allows you to 
%   specify additional parameter values to improve the forecasts.
%   Parameter values are:
%
%           'type'          the combination technique applied to combine
%           the individual forecasts. The current available methods are the
%           simple averaging schemes 'mean' and 'median', and the weighted
%           discount method of Stock and Watson (2004), aproached through 
%           typing 'weight'. In case one selects for 'weight' additional
%           parameters values are needed for the input: 'q0' and
%           (optionally) 'theta', see below for the description.
%
%           'q0'            the length of the hold-out-period
%
%           'theta'         the discount factor in case of weighted
%           combination of the individual forecasts. Smaller than 1 means 
%           that recent observations have more infuence in calculating the 
%           weights. In case this value is not specified, the combinefc
%           function sets this parameter equal to 0.9 as default.
%
%
%   [YIV, EIV] = INDIVFC(...) returns the 'n' by '1' vectors:
%       'Yc'      the combined forecasts
%       'Ec'      the realized prediction errors

%  Semin Ibisevic (2011)
%  $Date: 6/10/2011 20:02:34 $

% References
% J. H. Stock and M. W. Watson. Combination forecasts of output growth in
% a seven-country data set. Journal of Economic Literature, 23:405-430,
% 2004.

if nargin < 2
    error('stats:combinefc:TooFewInputs','At least three arguments are required');
end

if nargin < 3 || isempty(type), type = 'mean'; end
if isequal(type,'weight') && nargin < 4
    error('stats:combinefc:TooFewInputs','The weight combination requires additional input values.');
end
if isequal(type,'weight') && nargin < 5, theta = 0.9; end

if isequal(type,'mean') || isequal(type,'median') || isequal(type,'weight')
    % type is correctly specified
else
    error('type:combinefc:InvalidInput','Only mean, median and weight allowed');
end

% initialization
n = size(y,1);
k = size(Yiv,2);
m = sum(Yiv == 0,1)+1;

% Combine the individual forecasts through the regimes mean, median or
% weight
switch type
    case 'mean'
        Yc = mean(Yiv,2);
        Ec = zeros(n,k);
        Ec(m:n) = y(m:n)-Yc(m:n);
    case 'median'
        Yc = median(Yiv,2);
        Ec = zeros(n,k);
        Ec(m:n) = y(m:n)-Yc(m:n);
    case 'weight'
        Yc = zeros(n+1,1);
        Ec = zeros(n,1);
        
        MSE =  zeros(n,k);
        ThetaVec = zeros(n,1);
        
        for t = m+q0:n
            MSE(m:n,:) = (repmat(y(m:n,:),1, k )- Yiv(m:n,:)).^2;
            ThetaVec(m:t-1,1) = theta.^(t-m-1:-1:0)';
            Psi = (sum(repmat(ThetaVec,1, k ).*MSE)').^(-1);
            Psi = Psi/sum(Psi);
            Yc(t+1,1) = (Psi') * Yiv(t+1,:)';
            if t < n
                Ec(t+1,1) = y(t+1) - Yc(t+1,1);
            end
        end
        
end