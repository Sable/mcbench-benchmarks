function val = simAssetPrice_2GPU(TimeSeries, Period, nYears, nTrials)
% SIMASSETPRICE_2 simulates the asset prices series in a Monte Carlo
% simulation.  Is identical to simAssetPrice_2, but uses GPUs for the
% random number generation.

[expReturn, expCov] = calcExpMoments(TimeSeries, Period);
nAssets = size(expCov,1);
StartAssetPrice = TimeSeries(end, :)';

T = cholcov(expCov);
randNums = gpuArray.randn(nTrials*nYears, nAssets);
randNums = permute(reshape(randNums * T, nTrials, nYears, nAssets), [2,3,1]);
returns = bsxfun(@plus, randNums, expReturn);
StartAssetPrice = repmat(gpuArray(StartAssetPrice'), [1,1,nTrials]);
val = cumprod([StartAssetPrice; 1 + returns]);

val(val<0) = 0;

end

function [expReturn, expCov] = calcExpMoments(TimeSeries, Period)
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