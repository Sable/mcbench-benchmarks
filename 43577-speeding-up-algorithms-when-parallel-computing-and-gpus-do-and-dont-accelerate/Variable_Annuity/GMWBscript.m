%% GMWB Script for GPUs
% This script is adapted from the code for the MathWorks webinar "Modeling
% Variable Annuities with MATLAB" found at:
%
% http://www.mathworks.com/matlabcentral/fileexchange/26960-modeling-variable-annuities-with-matlab
%
% It is designed to highlight some of the coding considerations that must
% be addressed if one wishes to move such an analysis from a CPU
% environment onto a GPU.
%
% Original: Yi Wang, MathWorks, 2010
% Adapted: Michael Weidman, Quantitative Support Services, Ltd., 2013

%% 1. Set Parameters and Load Data

annualFee               = 0.005;
riskFreeRate            = 0.05;
annualWithdrawalRate    = 0.07;
nYears                  = 20;

nTrials                 = 1e5;

% Investment Portfolio
Ticker = {'MMM', 'AA', 'AXP', 'T', 'BAC', 'BA', 'CAT', 'CVX', 'CSCO', 'KO'};

% Range for historical data
FromDate    = '01/01/2000';
ToDate      = '01/01/2010';
Period      = 'm'; % Monthly data

% Assume we're holding 10 shares of each stock in our portfolio
Holdings = 10*ones(length(Ticker), 1);

TimeSeries = getEquityData(Ticker, FromDate, ToDate, Period);

dispResults('header')

%% 2. Price GMWB I: Original Code

tic

assetPrice = simAssetPrice_orig(TimeSeries, Period, nYears, nTrials);

[AccountVal, PayoutVal, FeeVal] = calcValuePayoutAndFees_orig( ...
    Holdings, assetPrice, annualWithdrawalRate, annualFee);

toc1 = toc;

cost = pvvar(mean(PayoutVal, 2), riskFreeRate);
fee = pvvar(mean(FeeVal, 2), riskFreeRate);
probRuin = calcProbRuin(AccountVal);

dispResults('Original', cost, fee, probRuin, toc1)

%% 3. Price GMWB II: Vectorized Code, GPU

tic

assetPrice = simAssetPrice_orig(TimeSeries, Period, nYears, nTrials);

HoldingsG               = gpuArray(Holdings);
assetPriceG             = gpuArray(assetPrice);
annualWithdrawalRateG   = gpuArray(annualWithdrawalRate);
annualFeeG              = gpuArray(annualFee);

[AccountValG, PayoutValG, FeeValG] = calcValuePayoutAndFees_GPU( ...
    HoldingsG, assetPriceG, annualWithdrawalRateG, annualFeeG);

AccountVal  = gather(AccountValG);
PayoutVal   = gather(PayoutValG);
FeeVal      = gather(FeeValG);

toc1 = toc;

cost = pvvar(mean(PayoutVal, 2), riskFreeRate);
fee = pvvar(mean(FeeVal, 2), riskFreeRate);
probRuin = calcProbRuin(AccountVal);

dispResults('Vectorized, GPU', cost, fee, probRuin, toc1)

%% 4. Price GMWB III: Vectorized Code, CPU

tic

assetPrice = simAssetPrice_orig(TimeSeries, Period, nYears, nTrials);

[AccountVal, PayoutVal, FeeVal] = calcValuePayoutAndFees_VEC( ...
    Holdings, assetPrice, annualWithdrawalRate, annualFee);

toc1 = toc;

cost = pvvar(mean(PayoutVal, 2), riskFreeRate);
fee = pvvar(mean(FeeVal, 2), riskFreeRate);
probRuin = calcProbRuin(AccountVal);

dispResults('Vectorized, CPU', cost, fee, probRuin, toc1)

%% 5. Price GMWB IV: GPU for RNG, Vectorized CPU for rest

tic

assetPriceG = simAssetPrice_2GPU(TimeSeries, Period, nYears, nTrials);
assetPrice = gather(assetPriceG);

[AccountVal, PayoutVal, FeeVal] = calcValuePayoutAndFees_VEC( ...
    Holdings, assetPrice, annualWithdrawalRate, annualFee);

toc1 = toc;

cost = pvvar(mean(PayoutVal, 2), riskFreeRate);
fee = pvvar(mean(FeeVal, 2), riskFreeRate);
probRuin = calcProbRuin(AccountVal);

dispResults('Best: GPU & CPU', cost, fee, probRuin, toc1)

%% 6. Price GMWB V: CPU only with new RNG and Vectorized code
% This optional section confirms that the GPU + CPU method in the previous
% section is the fastest: Using the GPU to generate random numbers should
% be slightly faster that this (CPU-only) section.

tic

assetPrice = simAssetPrice_2(TimeSeries, Period, nYears, nTrials);

[AccountVal, PayoutVal, FeeVal] = calcValuePayoutAndFees_VEC( ...
    Holdings, assetPrice, annualWithdrawalRate, annualFee);

toc1 = toc;

cost = pvvar(mean(PayoutVal, 2), riskFreeRate);
fee = pvvar(mean(FeeVal, 2), riskFreeRate);
probRuin = calcProbRuin(AccountVal);

dispResults('2nd Best: CPU-only', cost, fee, probRuin, toc1)