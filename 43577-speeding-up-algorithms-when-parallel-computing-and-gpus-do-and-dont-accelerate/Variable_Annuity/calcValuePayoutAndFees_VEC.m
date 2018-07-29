function [AccountVal, PayoutVal, FeeVal] = calcValuePayoutAndFees_VEC( ...
    Holdings_0, assetPrice, annualWithdrawalRate, annualFee)
% CALCVALUEPAYOUTANDFEES_VEC estimates the account value, the payout
% amounts, and the fees collected for a Monte Carlo simulation of the GMWB.
%
% It makes some changes to the original version by vectorizing across the
% MC runs.  It is identical to the GPU flavor but runs on a CPU instead.
%
% Inputs: 
% Holdings_0: An nAssets-by-1 vector of initial portfolio holdings, in
%   shares 
% assetPrice: An nYears-by-nAssets-by-nTrials matrix of simulated asset
%   prices
% annualWithdrawalRate: A scalar indicating the fraction of the initial
%   portfolio value that the customer is guaranteed to withdraw each year
% annualFee: A scalar indicating the fraction of the current portfolio
%   value that the insurer may assess each year
%
% Outputs: All are of size nYears+1-by-nTrials.  The first row
%   is for the initial year (t = 0)
% AccountVal: The total portofolio value after withdrawals.
% PayoutVal: The amount paid by the insurer to the customer if there is a
%   shortfall
% FeeVal: The amount collected by the insurer if funds remain in the
%   account

[nYears, ~, nTrials] = size(assetPrice);

AccountVal  = nan(nYears, nTrials);
PayoutVal   = nan(nYears, nTrials);
FeeVal      = nan(nYears, nTrials);

% for iTrial = 1:nTrials

% Initialize values at time 0.
currentHoldings      = repmat(Holdings_0', [1,1,nTrials]);
currentPrice         = assetPrice(1, :, :);
AccountVal(    1, :) = sum(currentPrice .* currentHoldings, 2);
PayoutVal(     1, :) = 0;
FeeVal(        1, :) = 0;

guaranteedWithdrawal = ...
    assetPrice(1, :, 1) * Holdings_0 * annualWithdrawalRate;

for iYear = 2:nYears
    currentPrice    = assetPrice(iYear, :, :);
    curPortVal      = sum(currentPrice .* currentHoldings, 2);
    totalWithdrawal = curPortVal * annualFee + guaranteedWithdrawal;
    
    FeeVal(iYear, :) = curPortVal * annualFee;
    
    [currentHoldings, shortfall] = updateHoldings(currentPrice, ...
        currentHoldings, totalWithdrawal);
    
    PayoutVal(iYear, :) = shortfall;
    AccountVal(iYear, :) = sum(currentPrice .* currentHoldings, 2);
end
end


function [holdings, shortfall] = updateHoldings(currentPrice, currentHoldings, totalWithdrawal)
% Adjusts the current holdings and calculates the shortfall given the
% pre-withdrawal holdings, the withdrawal, and the current asset prices.
%
% Is now written in a highly-vectorized form to handle all MC simulations
% in a single call.  The (more scalar) IF/ELSE logic has been replaced with
% a (more vectorized) logical mask construct.


holdings = currentHoldings;
shortfall = totalWithdrawal;

% 1. We're already bankrupt.  holdings and shortfall are straightforward
curPortVal = currentHoldings .* currentPrice;
alreadyBankruptMask = all(curPortVal == 0, 2);
holdings(:,:,alreadyBankruptMask) = 0;

% 2. We have just become bankrupt.  holdings and shortfall are also
% straightforward.
newPortVal = curPortVal - bsxfun(@times, curPortVal, totalWithdrawal ./ sum(curPortVal, 2));
newBankruptMask = sum(newPortVal, 2) <= 0 & ~alreadyBankruptMask;
holdings(:,:,newBankruptMask) = 0;
shortfall(newBankruptMask) = -sum(newPortVal(:,:,newBankruptMask), 2);

% 3. After withdrawal, all assets still have a positive or 0 balance.  Shortfall
% is 0 and adjust holdings as appropriate.
allPositiveMask = all(newPortVal >= 0, 2);
shortfall(allPositiveMask) = 0;
holdingsTmp = newPortVal(:,:,allPositiveMask) ...
    ./ currentPrice(:,:,allPositiveMask);
holdingsTmp(~isfinite(holdingsTmp)) = 0;
holdings(:,:,allPositiveMask) = holdingsTmp;

% 4. Since we are withdrawing proportional to the current holdings, there
% ought not be a 4th case.  It might be possible, though, due to roundoff
% error: consider this as equivalent to newly going bankrupt with no
% shortfall.
roundoffCase = ~(alreadyBankruptMask | newBankruptMask | allPositiveMask);
holdings(:,:,roundoffCase) = 0;
shortfall(roundoffCase) = 0;

end