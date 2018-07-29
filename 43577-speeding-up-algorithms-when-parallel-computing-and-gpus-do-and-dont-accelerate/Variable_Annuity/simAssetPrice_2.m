function val = simAssetPrice_2(TimeSeries, Period, nYears, nTrials)
% SIMASSETPRICE_2 simulates the asset prices series in a Monte Carlo
% simulation.  Is similar to simAssetPrice_orig, but removes dependence on
% the GBM object (at some expense to readibility).

[expReturn, expCov] = calcExpMoments(TimeSeries, Period);
nAssets = size(expCov,1);
StartAssetPrice = TimeSeries(end, :)';

T = cholcov(expCov);
randNums = randn(nTrials*nYears, nAssets);
randNums = permute(reshape(randNums * T, nTrials, nYears, nAssets), [2,3,1]);
returns = bsxfun(@plus, randNums, expReturn);
StartAssetPrice = repmat(StartAssetPrice', [1,1,nTrials]);
val = cumprod([StartAssetPrice; 1 + returns]);

val(val<0) = 0;

end

function [expReturn, expCov] = calcExpMoments(TimeSeries, Period)
% Estimates and annualizes the expected returns and covariances for the
% given time series
returns     = price2ret(TimeSeries);
expReturn   = mean(returns);
expCov      = cov(returns);

% Annualize monthly, weekly and daily returns and correlations
if Period == 'm'
    [expReturn, expCov] = arith2geom(expReturn, expCov, 12);
elseif Period == 'w'
    % Not implemented
elseif Period == 'd'
    % Not implemented
else
    % Do nothing
end

end