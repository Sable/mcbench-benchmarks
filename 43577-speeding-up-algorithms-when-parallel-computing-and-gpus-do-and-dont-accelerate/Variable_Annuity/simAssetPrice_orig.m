function val = simAssetPrice_orig(TimeSeries, Period, nYears, nTrials)
% SIMASSETPRICE_ORIG simulates the asset prices series in a Monte Carlo
% simulation.  Borrowed from the original MathWorks webinar and uses the
% GBM object from Econometrics Toolbox.

[expReturn, sigma, correlation] = calcRetSigCorr(TimeSeries, Period);

StartAssetPrice = TimeSeries(end, :)';

obj = gbm(diag(expReturn), diag(sigma), 'Correlation', correlation, 'StartState', StartAssetPrice);
dt  = 1;
val = obj.simulate(nYears, 'DeltaTime', dt, 'nTrials', nTrials);

val(val < 0) = 0;

end

function [expReturn, sigma, correlation] = calcRetSigCorr(TimeSeries, Period)
% Estimates and annualizes the expected returns, standard variations, and
% correlations for the given time series

returns     = price2ret(TimeSeries);
expReturn   = mean(returns);
sigma       = std(returns);
correlation = corrcoef(returns);

% Annualize monthly, weekly and daily returns and correlations
if Period == 'm'
    [expReturn, expCov] = arith2geom(mean(returns), cov(returns), 12);
    sigma = diag(sqrt(expCov));
    correlation = corrcov(expCov);
    expReturn = expReturn';
elseif Period == 'w'
    % Not implemented
elseif Period == 'd'
    % Not implemented
else
    % Do nothing
end

end