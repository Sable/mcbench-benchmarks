function simPrices = simulatePrices(expReturns, expCovariances, ...
    price0, allTimes)
% SIMULATEPRICES: calculate Monte Carlo prices for a set of correlated
% assets
%
% INPUTS:
% expReturn: a 1-by-nAssets vector of expected returns
% expCovariances: a nAssets-by-nAssets matrix of expected covariances
% price0: a 1-by-nAssets of initial asset prices
% allTimes: an nTimes-by-1 vector of integer times for which we need to
%   calculate the prices (ex. [30 90 180]' for 1-, 3-, and 6-month prices)
% nSims: a scalar integer for the number of Monte Carlo paths generated
%
% OUTPUT:
% simPrices: an nTimes-by-nAssets matrix of the simulated prices at the
% requested times.
%
% The variables expReturns, expCovariances, and allTimes share the same
% units-- if allTimes is in units of days, then the returns and covariances
% must be _daily_ moments.

% Calculates correlated, multivariate, normally-distributed numbers.  Uses
% Statistics Toolbox.
simReturns = mvnrnd(expReturns, expCovariances, max(allTimes));

% Convert simple returns to prices
simPrices = cumprod([price0; simReturns+1]);

% Downsample to only the times requested.  The first row is t==0 (i.e.:
% price0)
simPrices = simPrices(allTimes+1, :);