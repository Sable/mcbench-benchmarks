function [rU, WU, CU, HU] = uncovered_engine(X, T, ...
	initial_equity, distribution, risk_free_rate, stock_cost)
%uncovered_engine - Generate scenarios for an uncovered and a covered buy-write strategy.
%
%	[rU, WU, CU, HU] = uncovered_engine(X, T, ...
%	 	initial_equity, distribution, risk_free_rate, stock_cost);
%
% Inputs:
%	Stock Information
%		X - Stock total return prices including initial price [scalar].
%		T - Duration of investment period in years (terminal time - initial time) [scalar].
%	Fund Details
%		initial_equity - Initial (uncovered) total value of stock and cash held in asset [scalar].
%		distribution - Annualized fund distribution [scalar].
%	Other Details
%		risk_free_rate - Annualized risk-free rate [scalar].
%	Costs/Frictions
%		stock_cost - Proportional cost to buy or sell stock [scalar].
%
% Outputs:
%	rU - Total return for uncovered strategy [scalar].
%	WU - Sequence of total wealth for uncovered strategy [vector].
%	CU - Sequence of cash for uncovered strategy [vector].
%	HU - Sequence of holdings for uncovered strategy [vector].
%
% Comments:
%	1) This function generates scenarios for an uncovered portfolio strategy. To introduce some
%		degree of "realism" into the model, several inputs can be specified to control the
%		simulations. The next few comments provide additional details on these inputs.
%	2) X and T are stock total return prices and "times" in years that are assumed to be generated
%		by a geometric Brownian motion process with stochastic differential equation in the form
%			dX(t) = mu*X(t)*dt + volatility*X(t)*dB(t)
%		for t > 0.

% Copyright (C) 2012 The MathWorks, Inc.

% initialization

N = numel(X) - 1;				% N is the number of samples in X excluding the initial price
tau = T/N;						% tau is the time interval between samples in "years"

periods_per_day = floor(N/(252*T) + 0.5);	% periods_per_day is number of periods in a "day"

% initial position

current_price = X(1);									% initial price
current_time = 0;										% initial time

current_shares = floor(initial_equity/current_price);	% initial number of shares
current_cash = max(0, (initial_equity - current_shares*current_price));	% initial cash

initial_wealth = current_cash + current_shares*current_price;

% generate scenarios

% track shares, strike, cash, and wealth over time for testing

if nargout > 2
	HU = zeros(N+1,1);		% (H)oldings in stocks
	CU = zeros(N+1,1);		% (C)ash
	WU = zeros(N+1,1);		% (W)ealth
	
	HU(1) = current_shares;
	CU(1) = current_cash;
	WU(1) = current_cash + current_shares*current_price;
end

% loop over investment period for uncovered strategy

for iter = 2:N+1
	
	current_price = X(iter);
	current_time = tau*(iter - 1);
	
	% accrue interest on cash account at end of each day
	if mod(iter, periods_per_day) == 1		% note that period 1 happens outside loop
		current_cash = current_cash*(1 + risk_free_rate*tau*periods_per_day);
	end
	
	% buy more stock if enough cash available
	if current_cash > (current_price + stock_cost)
		adjusted_stock_price = current_price + stock_cost;
		shares_purchased = floor(current_cash/adjusted_stock_price);
		current_shares = current_shares + shares_purchased;
		current_cash = current_cash - shares_purchased*adjusted_stock_price;
	end
	
	% update test variables
	if nargout > 2
		HU(iter) = current_shares;
		CU(iter) = current_cash;
		WU(iter) = current_cash + current_shares*current_price;
	end
end

% at the end of the period, pay a distribution and sell shares if not enough cash

distribution = distribution*T;

needed_cash = distribution*(current_cash + current_shares*X(end)) - current_cash;

if needed_cash > 0
	adjusted_stock_price = X(end) + stock_cost;
	shares_sold = ceil(needed_cash/adjusted_stock_price);
	
	current_shares = current_shares - shares_sold;
	current_cash = current_cash + shares_sold*(X(end) - stock_cost);
	
	if nargout > 2
		HU(end) = current_shares;
		CU(end) = current_cash;
		WU(end) = current_cash + current_shares*X(end);
	end
end

% final scenario returns

rU = (current_cash + current_shares*X(end))/initial_wealth - 1;
