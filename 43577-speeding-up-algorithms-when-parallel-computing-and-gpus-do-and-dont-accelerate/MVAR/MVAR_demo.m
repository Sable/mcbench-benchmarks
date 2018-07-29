%% Distributed Marginal Value-at-Risk Simulation
% This example uses the Parallel Computing Toolbox(TM) to perform a Monte
% Carlo simulation of a number of stocks in a portfolio. At a given
% confidence level, we predict the value at risk (VaR) of the portfolio as
% well as the marginal value at risk (mVaR) of each of the stocks in the
% portfolio.  We also provide confidence intervals for our estimates.
%
%   Copyright 2007-2012 The MathWorks, Inc. 
%   Adapted and simplified in 2013 by Michael Weidman, Quantitative Support
%   Services, Ltd.

%% 1. Open a pool of MATLAB workers and load input data

if matlabpool('size') == 0
    matlabpool open
end

load pctdemo_data_mvar

%% 2. Define Parameters

nSims           = 1e5;
relativeWeights = [1 1 2 2 1 3 2]/12;
time            = 50;%(10:1:50)';
confLevel       = 95;

nTimes          = length(time);
nAssets         = size(stock,2);

%% 3. Estimate asset moments

returns         = (stock(2:end,:) - stock(1:end-1,:)) ./ stock(1:end-1,:);
expReturns      = mean(returns);
expCovariances  =  cov(returns);

%% 4. Simulate asset prices

tic

simPrices   = zeros(nTimes, nAssets, nSims); 
portPrices  = zeros(nTimes,       1, nSims);
price0      = stock(end,:);
portPrice0  = price0 * relativeWeights';

parfor iSim = 1:nSims
    simPrices( :,:,iSim) = simulatePrices(expReturns, expCovariances, ...
        price0, time);
    portPrices(:,:,iSim) = sum(bsxfun(@times, simPrices(:,:,iSim), ...
        relativeWeights), 2);
end

toc

%% 5. Calculate mVaR and VaR

simRelativeLosses = bsxfun(@rdivide, ...
    bsxfun(@minus, price0, simPrices), price0);
simRelativePortLosses = bsxfun(@minus, portPrice0, portPrices) ...
    ./ portPrice0;

mVaR = prctile(simRelativeLosses    , confLevel, 3);
VaR  = prctile(simRelativePortLosses, confLevel, 3);

%% 6. Plot the Results

plotMVAR(VaR, mVaR, time, names);