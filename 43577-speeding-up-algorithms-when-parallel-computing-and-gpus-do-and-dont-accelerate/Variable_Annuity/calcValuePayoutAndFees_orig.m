function [AccountVal, PayoutVal, FeeVal] = calcValuePayoutAndFees_orig( ...
    Holdings_0, assetPrice, annualWithdrawalRate, annualFee)
% CALCVALUEPAYOUTANDFEES_ORIG estimates the account value, the payout
% amounts, and the fees collected for a Monte Carlo simulation of the GMWB.
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
% Outputs: All have size nYears+1-by-nTrials.  The first row is for the
%   initial year (t = 0)
% AccountVal: The total portofolio value after withdrawals.
% PayoutVal: The amount paid by the insurer to the customer if there is a
%   shortfall
% FeeVal: The amount collected by the insurer if funds remain in the
%   account

[nYears, ~, nTrials] = size(assetPrice);

AccountVal  = nan(nYears, nTrials);
PayoutVal   = nan(nYears, nTrials);
FeeVal      = nan(nYears, nTrials);

for iTrial = 1:nTrials
    % Initialize values at time 0.
    currentHoldings      = Holdings_0;
    currentPrice         = assetPrice(1, :, iTrial);
    AccountVal(1,iTrial) = currentPrice * currentHoldings;
    PayoutVal(1, iTrial) = 0;
    FeeVal(   1, iTrial) = 0;
    guaranteedWithdrawal = currentPrice * currentHoldings * annualWithdrawalRate;
    
    for iYear = 2:nYears
        currentPrice    = assetPrice(iYear, :, iTrial);
        curPortVal      = currentPrice * currentHoldings;
        totalWithdrawal = curPortVal * annualFee + guaranteedWithdrawal;
        
        FeeVal(iYear, iTrial) = curPortVal * annualFee;
        
        [currentHoldings, shortfall] = updateHoldings(currentPrice, ...
            currentHoldings, totalWithdrawal);
        
        PayoutVal(iYear, iTrial) = shortfall;
        AccountVal(iYear, iTrial) = currentPrice * currentHoldings;
    end
end
end

function [holdings, shortfall] = updateHoldings(currentPrice, ...
    currentHoldings, totalWithdrawal)
% Adjusts the current holdings and calculates the shortfall given the
% pre-withdrawal holdings, the withdrawal, and the current asset prices.

holdings = currentHoldings;
currentPrice = currentPrice';
curPortVal = currentHoldings .* currentPrice;

if any(curPortVal > 0)
    % We still have some funds in the portfolio: apply withdrawals in the
    % best way possible by distributing withdrawals across the holdings
    % proportionately to their values:
    newPortVal = curPortVal - curPortVal.*totalWithdrawal/sum(curPortVal);
    
    if sum(newPortVal) > 0      % Still have fund left in the account
        shortfall = 0;
        holdings = newPortVal ./ currentPrice;
        holdings(~isfinite(holdings)) = 0;
    else
        % We've just gone bankrupt.  Set all holdings to 0 and pay out the
        % shortfall.
        shortfall = -sum(newPortVal);
        holdings(:) = 0;
    end
    
else
    % Every asset has zero value-- the calculation is straightforward.
    shortfall   = totalWithdrawal;
    holdings(:) = 0;
end

end