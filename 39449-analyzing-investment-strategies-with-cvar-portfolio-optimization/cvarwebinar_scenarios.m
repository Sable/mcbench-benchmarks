%% Analyzing Investment Strategies with CVaR Portfolio Optimization in MATLAB - Generate Scenarios
%
% Robert Taylor
% The MathWorks, Inc.

% Copyright (C) 2012 The MathWorks, Inc.

%% Introduction

% This script generates scenarios for a covered-call strategy with a portfolio of stocks. The stocks
% are assumed to have no dividends (dividends have been incorporated into total return prices in the
% data) and the call options are assumed to be American options. The covered-call strategy has
% scenarios for uncovered stocks and for covered positions at two different strike prices.
% Subsequent optimization steps can use any combination of these three possible collections of
% scenarios. The scenarios are written to the file |BuyWriteScenarios.mat|.

%% Get Stock Total Return Price Data

% The example starts with data from the file |BuyWriteStockUniverse.mat| that contains a fints
% object, Universe, with asset symbols and 15 years of daily total return prices for 26 stocks.

load BuyWriteStockUniverse Universe

% Extract information from fints object Universe.

Assets = fieldnames(Universe, 1);			% stock symbols
X = fts2mat(Universe);						% stock total return prices
numassets = numel(Assets);					% number of stocks in universe

%% Calibrate Geometric Brownian Motion

% Under an assumption that stock prices are geometric Brownian motion processes, the next step
% calibrates a continuous multivariate geometric Brownian motion process based on discrete samples
% of total return prices.

t0 = busdate(Universe.dates(1), -1);		% first business day prior to first date in data
T = Universe.dates(end);					% last date in data

% Determine average number of days in a year for the historical period. In this example, the period
% is known and fixed to be 15 years.

average_days_per_year = (T - t0)/15;

% Form "dates" for data relative to t0 in years based on average number of days in a year.

t = linspace(0, (T - t0), 1 + size(X,1))'/average_days_per_year;	% "dates" from t0 for data

% Calibrate the model with maximum likelihood estimation.

tic

[x0, mu, gamma] = gbm_calibration(t(1), X, t(2:end));

toc_cal = toc;

fprintf('Time to calibrate parameters %g\n',toc_cal);

% Form various ancillary statistics from the estimated diffusion matrix.

covar = gamma*gamma';
[sigma, rho] = cov2corr(covar);
sigma = sigma(:);

% List calibrated parameters.

fprintf('Calibrated multivariate geometric Brownian motion parameters ...\n');
fprintf('  %5s  %10s  %10s  %10s\n','Asset','Initial','Drift','Diffusion');
fprintf('  %5s  %10s  %10s  %10s\n','','Price','Parameter','Parameter');
for i = 1:numassets
	fprintf('  %5s  %10.2f  %10.2f  %10.2f\n',Assets{i},x0(i),100*mu(i),100*sigma(i));
end

%% Set up Investment Period for Scenarios

% To generate scenarios, it is necessary to specify a fixed period of time called an investment
% period. During an investment period, numerous actions can take place that are independent of the
% specific features of a particular financial instrument. To set up an investment period, pick start
% and end dates. For this strategy a good choice is to select a single month.

startdate = datenum('28-Sep-2012');			% start date for investment period
enddate = datenum('31-Oct-2012');			% end date for investment period

numdays = daysdif(startdate, enddate, 13);	% number of trading days in an investment period
t0 = 0;										% set initial time to be 0 years
T = numdays/252;							% terminal time is T years

%% Simulate Geometric Brownian Motion over an Investment Period

% Given an investment period and a calibrated geometric Brownian motion process, simulate stock
% prices for the underlying assets. Since the ultimate goal is to create a collection of scenarios
% for portfolio optimization, the number of scenarios is the number of trials for the stochastic
% process (note that a single trial has a path for each asset at the periodicity of the simulation
% and that the total return for the path is the scenario).

% Although the sampling rate for the simulation can be set to any value, this example uses half-hour
% increments. For the US markets, a trading day has 13 half-hour increments so this is the number of
% "ticks" per day.

num_ticks_per_day = 13;						% number of "tick" periods per day

% To simulate a multivariate geometric Brownian motion, three control parameters must be set that
% are the number of trials, the number of samples per trial, and the number of time steps between
% samples. Note that the number of trials is the number of scenarios to be generated for CVaR
% portfolio optimization and a good "typical" number is 20000.

numtrials = 20000;							% number of scenarios/trials/paths/realizations
numsamples = numdays*num_ticks_per_day;		% number of samples/observables per scenario
numsteps = 1;								% number of steps between samples

dt = (T - t0)/numsamples;					% time interval between samples in years

% Simulate multivariate stochastic process.

% Xsde is a gbm object with the parameters from the calibration step for the process.
% X is a (1 + numsamples) by numassets by numtrials array of sample paths for the process.
% t is a (1 + numsamples) vector that contains the "times" for each sample in the process.

tic

Xsde = gbm(diag(mu), diag(sigma), 'starttime', t0, 'startstate', x0, 'correlation', rho);

[X, t] = Xsde.simulate(numsamples, 'deltatime', dt, 'ntrials', numtrials, ...
	'nsteps', numsteps, 'antithetic', true);

toc_gbm = toc;

fprintf('Time to simulate gbm process %g with %g samples\n', ...
	toc_gbm,(1 + numsamples)*numassets*numtrials);

%% Set up Covered-Call Strategy

% To gather the necessary inputs to generate scenarios for a covered-call strategy, the final step
% requires specification of various parameters that control the simulation. The two parameters that
% are of primary focus are initiating, which specifies whether initial call premia are to be
% included in scenario returns, and exercise_likelihood, which specifies the characteristics of the
% likelihood of early exercise. Although some guidelines to set these parameters are provided here,
% the function |covered_engine.m| contains a complete description of each of these parameters.

% Fund features.

initial_equity = 1.0e6;			% initial wealth invested in portfolio
distribution = 0;				% annualized fund distribution rate
risk_free_rate = 0.0015;		% Treausury bill rate (annual yield), proxy for risk-free rate
no_reinvestment = false;		% true if no re-investment after assignment, false otherwise
initiating = true;				% true if initiating a call position, false if an ongoing position

% Call option features.

% Use a fixed expiration date for calls, including any calls that are rewritten. If the calls expire
% during the investment period, shift to the next contract expiration date. Select a date after the
% start date of the investment period. For this example with investment period end date, possible
% call expiration dates are: 19-Oct-2012, 16-Nov-2012, 21-Dec-2012, 18-Jan-2013, 15-Feb-2013,
% 15-Mar-2013, ... .

% The exercise_likelihood parameter is either NaN (to use a heuristic model) or a probability of
% early exercise if stock price >= strike price between start of investment period and option
% expiration.

near_contract = datenum('21-Dec-2012');		% near contract call option expiration date
next_contract = datenum('15-Mar-2013');		% next contract call option expiration date

contract_expiration = daysdif(startdate, near_contract, 13)/252;	% "anchor" expiration dates
next_contract_expiration = daysdif(startdate, next_contract, 13)/252;

strike_cushion = 0.05;				% "cushion" to set strike price above current stock price
exercise_likelihood = 0.99;			% likelihood of early exercise if stock price >= strike price

% Costs/frictions.

% For the simulation, basic transaction costs are 5 c/share for stocks and 20 c/contract for
% options. Average opportunity costs are assumed to be 1 c/share for stocks and 2 c/contract for
% options.

stock_cost = 0.06;							% 6 c/share
contract_cost = 0.22;						% 22 c/option contract

% Assignment and re-investment delays.

confirmation_delay = 2;						% 1 hour delay to confirm option assignment
reinvestment_delay = num_ticks_per_day;		% 1 day to reinvest after confirmation of assignment
settlement_delay = 3*num_ticks_per_day;		% 3 days to settle after reinvestment

%% Generate Scenarios for Uncovered and Covered Positions

% Generate scenarios by looping over the number of scenarios and the number of assets. The function
% |covered_engine.m| simulates covered-call scenarios and the function |uncovered_engine| simulates
% uncovered scenarios. Note that subsequent portfolio optimization steps may allocate weights to
% mixtures of covered and uncovered positions to form partial coverage of positions.

% WARNING: This step is slow.

tic

fprintf('Generating scenarios ...\n');

XU = zeros(numtrials, numassets);
XC1 = zeros(numtrials, numassets);
XC2 = zeros(numtrials, numassets);

for iter = 1:numtrials
	for i = 1:numassets
		
		rU = uncovered_engine(X(:,i,iter), T, ...
			initial_equity, distribution, risk_free_rate, stock_cost);

		rC1 = covered_engine(X(:,i,iter), T, mu(i), sigma(i), ...
			initial_equity, distribution, no_reinvestment, initiating, ...
			strike_cushion, contract_expiration, next_contract_expiration, risk_free_rate, ...
			stock_cost, contract_cost, exercise_likelihood, ...
			confirmation_delay, reinvestment_delay, settlement_delay);

		rC2 = covered_engine(X(:,i,iter), T, mu(i), sigma(i), ...
			initial_equity, distribution, no_reinvestment, initiating, ...
			2*strike_cushion, contract_expiration, next_contract_expiration, risk_free_rate, ...
			stock_cost, contract_cost, exercise_likelihood, ...
			confirmation_delay, reinvestment_delay, settlement_delay);
		
		XU(iter, i) = rU;
		XC1(iter, i) = rC1;
		XC2(iter, i) = rC2;
	end
	if mod(iter, 1000) == 0
		fprintf('Completed %d scenarios ...\n',iter);
	end
end

toc_scenarios = toc;

fprintf('Time to simulate scenarios %g\n',toc_scenarios);

%% Save scenarios

% Save scenarios in the file |BuyWriteScenarios.mat|.

save('./data/BuyWriteScenarios.mat','Assets','XU','XC1','XC2','exercise_likelihood','initiating');
