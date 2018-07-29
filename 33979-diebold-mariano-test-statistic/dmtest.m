function DM = dmtest(e1, e2, h)
%DMTEST: Retrieves the Diebold-Mariano test statistic (1995) for the 
% equality of forecast accuracy of two forecasts under general assumptions.
%
%   DM = dmtest(e1, e2, ...) calculates the D-M test statistic on the base 
%   of the loss differential which is defined as the difference of the 
%   squared forecast errors
%
%   In particular, with the DM statistic one can test the null hypothesis: 
%   H0: E(d) = 0. The Diebold-Mariano test assumes that the loss 
%   differential process 'd' is stationary and defines the statistic as:
%   DM = mean(d) / sqrt[ (1/T) * VAR(d) ]  ~ N(0,1),
%   where VAR(d) is an estimate of the unconditional variance of 'd'.
%
%   This function also corrects for the autocorrelation that multi-period 
%   forecast errors usually exhibit. Note that an efficient h-period 
%   forecast will have forecast errors following MA(h-1) processes. 
%   Diebold-Mariano use a Newey-West type estimator for sample variance of
%   the loss differential to account for this concern.
%
%   'e1' is a 'T1-by-1' vector of the forecast errors from the first model
%   'e2' is a 'T2-by-1' vector of the forecast errors from the second model
%
%   It should hold that T1 = T2 = T.
%
%   DM = DMTEST(e1, e2, 'h') allows you to specify an additional parameter 
%   value 'h' to account for the autocorrelation in the loss differential 
%   for multi-period ahead forecasts.   
%       'h'         the forecast horizon, initially set equal to 1
%
%   DM = DMTEST(...) returns a constant:
%       'DM'      the Diebold-Mariano (1995) test statistic
%
%  Semin Ibisevic (2011)
%  $Date: 11/29/2011 $
%
% -------------------------------------------------------------------------
% References
% K. Bouman. Quantitative methods in international finance and 
% macroeconomics. Econometric Institute, 2011. Lecture FEM21004-11.
% 
% Diebold, F.X. and R.S. Mariano (1995), "Comparing predictive accuracy", 
% Journal of Business & Economic Statistics, 13, 253-263.
% -------------------------------------------------------------------------

if nargin < 2
    error('dmtest:TooFewInputs','At least two arguments are required');
end
if nargin < 3
   h = 1; 
end
if size(e1,1) ~= size(e2,1) || size(e1,2) ~= size(e2,2)
    error('dmtest:InvalidInput','Vectors should be of equal length');
end
if size(e1,2) > 1 || size(e2,2) > 1
    error('dmtest:InvalidInput','Input should have T rows and 1 column');
end

% Initialization
T = size(e1,1);

% Define the loss differential
d = e1.^2 - e2.^2;

% Ralculate the variance of the loss differential, taking into account
% autocorrelation.
dMean = mean(d);
gamma0 = var(d);
if h > 1
    gamma = zeros(h-1,1);
    for i = 1:h-1
        sampleCov = cov(d(1+i:T),d(1:T-i));
        gamma(i) = sampleCov(2);
    end
    varD = gamma0 + 2*sum(gamma);
else
    varD = gamma0;
end

% Retrieve the diebold mariano statistic DM ~N(0,1)
DM = dMean / sqrt ( (1/T)*varD );       
    


