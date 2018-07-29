%% Analyzing Investment Strategies with CVaR Portfolio Optimization in MATLAB - Reality
%
% Robert Taylor
% The MathWorks, Inc.

% Copyright (C) 2012 The MathWorks, Inc.

%% Introduction

% This script illustates the simulation of a single realization for both uncovered and covered-call
% positions on a common underlying stock price realization obtained from the file
% |BuyWriteTestData.mat|.

%% Generate a Single Realization for Uncovered and Covered-Call Scenarios

% Example:
%	Assume data are sampled at 30-minute intervals over 22 days. Assume that a "year" is 252 days,
%	that a "day" is from 09:30 to 14:00, and that a "period" is 30 minutes. Consequently, a "day"
%	comprises 13 "periods" with 1 + 22*13 samples and the investment period is 22/252 years. Note
%	that the extra sample is the initial price.
%
%	X(1)				40			initial price of stock
%	numel(X)			1 + 22*13	initial price plus 13 30-minute periods in a day for 22 days
%	T					22/252		investment period has 22 days with 252 days in a year
%	volatility			0.35		35% volatility
%
%	initial_equity		1000000		$1 million initial equity invested in stock (25000 shares)
%	distribution		0.10		10% per year distribution
%
%	option_expiration	45/252		option expiration in 45 days
%	risk_free_rate		0.0015		0.15% risk-free rate
%	strike_cushion		0.05		5% strike price "cushion"
%	exercise_likelihood 0.2			probability of exercise if stock price >= strike price

%	stock_cost			0.06		5 c/share txcost + 1 c/share spread
%	option_cost			0.20		20 c/option contract

%	confirmation_delay	2			1 hour delay to confirm option assignment
%	reinvestment_delay	1*13		1 day to reinvest after confirmation of assignment
%	settlement_delay	3*13		3 days to settle after reinvestment

% fund details

distribution = 0.10;

% initial number of shares invested in stock

initial_holdings = 25000;			% initial number of shares

% investment period
%	periodicity is 30-minute periods, 13 periods in a day, 252 days in a year

T = 22/252;							% duration of investment period is 22 days
N = 22*13;							% 22 days x 13 30-minute periods in a day

% stock information

load BuyWriteTestData X				% realization of asset total return prices X

initial_price = X(1);				% initial price
mu = 0.10;							% stock drift
volatility = 0.35;					% stock volatility

initial_equity = initial_holdings*initial_price;

% option information

contract_expiration = 45/252;		% option contract expiration (45 days)
next_contract_expiration = 112/252;	% next option contract expiration (112 days)
risk_free_rate = 0.0015;			% risk-free rate
strike_cushion = 0.05;				% strike price "cushion"
% exercise_likelihood = NaN;		% period probability of exercise if stock price >= strike price
exercise_likelihood = 0.9;			% period probability of exercise if stock price >= strike price

% costs/frictions

stock_cost = 0.06;					% 5 c/share txcost + 1 c/share spread
contract_cost = 0.20;				% 20 c/option contract + 2 c/option contract spread

% delays

confirmation_delay = 2;				% 1 hour delay to confirm option assignment
reinvestment_delay = 1*13;			% 1 day to reinvest after confirmation of assignment
settlement_delay = 3*13;			% 3 days to settle after reinvestment

no_reinvestment = false;			% true if reinvestment not allowed in an investment period
% no_reinvestment = true;			% true if reinvestment not allowed in an investment period
covered_vs_uncovered = false;

% simulate scenarios

[rU, WU, CU, HU] = uncovered_engine(X, T, ...
	initial_equity, distribution, risk_free_rate, stock_cost);

[rC, WC, CC, HC, KC] = covered_engine(X, T, mu, volatility, ...
	initial_equity, distribution, no_reinvestment, covered_vs_uncovered, ...
	strike_cushion, contract_expiration, next_contract_expiration, risk_free_rate, ...
	stock_cost, contract_cost, exercise_likelihood, ...
	confirmation_delay, reinvestment_delay, settlement_delay);

fprintf('Scenario total returns ...\n');
fprintf('  Uncovered  %10.4f  Total return for uncovered strategy\n',rU);
fprintf('  Covered    %10.4f  Total return for covered strategy\n',rC);

fprintf('Mean of total returns ...\n');
fprintf('  Uncovered  %10.4f\n',N*mean(tick2ret(WU)));
fprintf('  Covered    %10.4f\n',N*mean(tick2ret(WC)));

fprintf('Standard deviation of total returns ...\n');
fprintf('  Uncovered  %10.4f\n',sqrt(N)*std(tick2ret(WU)));
fprintf('  Covered    %10.4f\n',sqrt(N)*std(tick2ret(WC)));

fprintf('Maximum drawdown of total returns ...\n');
fprintf('  Uncovered  %10.4f\n',maxdrawdown(WU));
fprintf('  Covered    %10.4f\n',maxdrawdown(WC));

%% Plot Results

t = linspace(0, T*252, N+1);

subplot(2,2,1);
plot(t, [WC/WC(1), WU/WU(1)]);
title('\bfTotal Wealth');
xlabel('Day');
ylabel('Dollars (Millions)');
h = legend('Covered', 'Uncovered', 'Location', 'SouthEast');
set(h, 'FontSize', 7, 'Box', 'off');

subplot(2,2,2);
plot(t, 1.0e-6*CC);
title('\bfCash');
xlabel('Day');
ylabel('Dollars (Millions)');

subplot(2,2,3);
plot(t, 1.0e-3*HC);
title('\bfShares');
xlabel('Day');
ylabel('Shares (Thousands)');

subplot(2,2,4);
plot(t, KC);
title('\bfStrike Price');
xlabel('Day');
ylabel('Dollars');
