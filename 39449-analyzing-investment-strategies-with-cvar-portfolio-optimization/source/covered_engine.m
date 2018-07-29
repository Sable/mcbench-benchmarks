function [rC, WC, CC, HC, KC] = covered_engine(X, T, mu, sigma, ...
	initial_equity, distribution, no_reinvestment, initiating, ...
	strike_cushion, contract_expiration, next_contract_expiration, risk_free_rate, ...
	stock_cost, contract_cost, exercise_likelihood, ...
	confirmation_delay, reinvestment_delay, settlement_delay)
%covered_engine - Generate scenarios for a covered-call strategy with expiration.
%
%	[rC, WC, CC, HC, KC] = covered_engine(X, T, mu, sigma, ...
%		initial_equity, distribution, no_reinvestment, initiating, ...
%		strike_cushion, contract_expiration, next_contract_expiration, risk_free_rate, ...
%		stock_cost, contract_cost, exercise_likelihood, ...
%		confirmation_delay, reinvestment_delay, settlement_delay);
%
% Inputs:
%	Stock Information
%		X - Stock total return prices including initial price [scalar].
%		T - Duration of investment period in years (terminal time - initial time) [scalar].
%		mu - Annaulized stock drift parameter [scalar].
%		sigma - Annualized stock volatility parameter [scalar].
%	Fund Details
%		initial_equity - Initial (uncovered) total value of stock and cash held in asset [scalar].
%		distribution - Annualized fund distribution [scalar].
%		no_reinvestment - If true, then no reinvestment permitted until next investment period if
%			assigned during current investment period. If false, then reinvestment is permitted
%			[scalar].
%		initiating - If true, then initiating covered-call during current investment period period.
%			If false, then ongoing covered-call so that initial call premium does not contribute to
%			total return for the period [scalar].
%	Option Details
%		strike_cushion - Strike price "cushion" as a percentage above current price [scalar].
%		contract_expiration - Option expiration from initial time in years [scalar].
%		next_contract_expiration - Next option contract expiration from initial time in years
%			[scalar].
%		risk_free_rate - Annualized risk-free rate [scalar].
%	Costs/Frictions
%		stock_cost - Proportional cost to buy or sell stock [scalar].
%		contract_cost - Proportional cost to write option [scalar].
%		exercise_likelihood - Probability than an at-the-money or in-the-money call will be
%			exercised early (see comments) [scalar].
%	Strategy Information
%		confirmation_delay - Number of periods delay to confirm assignment [scalar].
%		reinvestment_delay - Number of periods delay to reinvest in stock after assignment [scalar].
%		settlement_delay - Number of periods delay to settle reinvested stock position [scalar].
%
% Outputs:
%	rC - Total return for covered strategy [scalar].
%	WC - Sequence of total wealth for covered strategy [vector].
%	CC - Sequence of cash for covered strategy [vector].
%	HC - Sequence of holdings for covered strategy [vector].
%	KC - Sequence of strike prices for covered strategy [vector].
%
% Comments:
%	1) This function generates scenarios for a covered-call strategy based on numerous assumptions.
%		At a fundamental level, it employs two distinct approaches to generate such scenarios that
%		depend upon whether the scenario is an initiating or an ongoing covered-call position. To
%		introduce some degree of "realism" into the model, numerous inputs can be specified to
%		control the simulations. The next few comments provide additional details on these inputs.
%	2) X and T are stock total return prices and "times" in years that are assumed to be generated
%		by a geometric Brownian motion process with stochastic differential equation in the form
%			dX(t) = mu*X(t)*dt + sigma*X(t)*dB(t)
%		for t > 0.
%	3) No naked or recursive calls and no rollovers allowed.
%	4) If exercise_likelihood is a number, it is the probability that an assignment might occur at
%		any time between the initial time and the contract expiration. If the exercise_likelihood
%		is a NaN, this function computes a probability based on heuristics that generally results in
%		very low probabilities of exercise. Both approaches have increasing probabilities as the
%		time approaches contract expiration.
%	5) The probability of early exercise is derived from the underlying parameters for the geometric
%		Brownian motion of the stock price, where the probability of early exercise is assumed to be
%		equal to the probability that the stock price will be above the strike price at expiration.
%		Note that this probability is different than the probability associated with moneyness.
%	6) Assignment occurs when a call option is exercised which means that the investor must deliver
%		stock in exchange for the strike price of the call option. This function loops over an
%		investment period and, depending upon the state of the position at each time, determines
%		whether to exercise, assign, reinvest, settle, or write a new call. If the option expires
%		during the investment period, assignment always occurs if the option expires in-the-money
%		and the new covered call position is written with the next contract expiration.
%	7) The last three inputs are the variables confirmation_delay, reinvestment_delay, and
%		settlement_delay. They indicate fixed amounts of time that an assigned covered call position
%		spends in different states associated with the assignment and reinvestment process. These
%		variables are specified as durations at the periodicity of the simulation. For example, if
%		the time between samples is 30 minutes, a delay of 4 implies a 2-hour delay.
%	8) The delays are:
%		confirmation_delay
% 			The first delay is a confirmation delay. Once an assignment has occurred (based on the
% 			probability of early exercise), a small delay may exist before the assignment is
% 			confirmed. This delay can be due to either delays in notification or delays in response.
% 			Typically it is a small value although index options can have 24 hour confirmation
% 			delays. At the end of this period, the cash from exercise shows up in the account and
% 			the stock has been delivered.
% 		reinvestment_delay
% 			Once assignment has occurred, the next delay is the time needed to reinvest (if the
% 			no_reinvestment flag is false). Although small portfolios many have no delay for
% 			reinvestment of the cash in the underlying assets, large portfolios can experience
% 			significant delays that contribute to opportunity costs. For this model, reinvestment is
% 			assumed to be a "laddered" approach over the period specified by reinvestment_delay. For
% 			example, if reinvestment_delay is 10, then the cash is reinvested in the stock in 10
% 			equal portions at the periodicity of the simulation.
% 		settlement_delay
% 			Once reinvestment has been completed, the next delay is settlement of the position. This
% 			is important since it is not possible to write a naked call on a position that has not
% 			yet settled. Typically, this delay is the "T+3" settlement time although, in this
% 			simulation, it is treated as an equivalent delay at the periodicity of the simulation.
% 			Once the settlement delay is complete, it is then possible to write a new call on the
% 			settled stock position.

% Copyright (C) 2012 The MathWorks, Inc.

% initialization

N = numel(X) - 1;				% N is the number of samples in X excluding the initial price
tau = T/N;						% tau is the time interval between samples in "years"

periods_per_day = floor(N/(252*T) + 0.5);	% periods_per_day is number of periods in a "day"

% event flags

assignment_state = false;		% true when an assignment is in progress, false otherwise

confirmation_state = false;		% assignment step 1, true until confirmation step has been completed
reinvestment_state = false;		% assignment step 2, true until reinvestment step has been completed
settlement_state = false;		% assignment step 3, true until settlement step has been completed

% initial position

current_price = X(1);									% initial price
current_time = 0;										% initial time

current_shares = floor(initial_equity/current_price);	% initial number of shares
current_cash = max(0, (initial_equity - current_shares*current_price));	% initial cash

uncovered_shares = current_shares;
uncovered_cash = current_cash;

% strike price is above stock price by the "cushion"
strike_price = (1 + strike_cushion)*current_price;

% strike prices in $1 increments for shares above $10 and $0.50 for shares below $10
if current_price <= 10
	strike_price = ceil(2*strike_price)/2;
else
	strike_price = ceil(strike_price);
end

% can use Black-Scholes option pricing formula for American options since no dividends
dt = contract_expiration - current_time;
current_call = gbm_call_price(current_price, strike_price, risk_free_rate, dt, sigma);

% call price is rounded down to nearest $0.01
current_call = floor(100*current_call)/100;

current_cash = current_cash + current_shares*(current_call - contract_cost);
current_strike = strike_price;

% distinguish between initiating and ongoing positions
uncovered_initial_wealth = uncovered_cash + uncovered_shares*current_price;
covered_initial_wealth = current_cash + current_shares*current_price;

% generate scenarios

% track shares, strike, cash, and wealth over time for testing

if nargout > 2
	HC = zeros(N+1,1);		% (H)oldings in stocks
	KC = zeros(N+1,1);		% stri(K)e price for current written call
	CC = zeros(N+1,1);		% (C)ash
	WC = zeros(N+1,1);		% (W)ealth
	
	HC(1) = current_shares;
	KC(1) = current_strike;
	CC(1) = current_cash;
	WC(1) = current_cash + current_shares*current_price;
end

% loop over investment period for covered strategy

for iter = 2:N+1
	
	% get current price and current time
	current_price = X(iter);
	current_time = tau*(iter - 1);
	
	% determine current states and progress within states
	if assignment_state
		% note that the assignment_state does not end until a new covered position is created
		
		% covered position is in assignment
		if confirmation_state

			% countdown for confirmation step
			confirmation_count = confirmation_count - 1;
			if confirmation_count == 0
				% at last confirmation period, deliver stock and receive strike
				current_cash = current_cash + current_shares*current_strike;
				current_shares = 0;

				% at last confirmation period, initiate reinvestment step
				confirmation_state = false;
				reinvestment_state = true;
				reinvestment_count = reinvestment_delay;
			end

		elseif reinvestment_state

			% reinvest in stocks during reinvestment period by "laddering"
			if ~no_reinvestment
				adjusted_stock_price = current_price + stock_cost;
				shares_purchased = floor(current_cash/(adjusted_stock_price*reinvestment_count));
				current_shares = current_shares + shares_purchased;
				current_cash = current_cash - shares_purchased*adjusted_stock_price;
			end

			% countdown for reinvestment step
			reinvestment_count = reinvestment_count - 1;
			if reinvestment_count == 0
				% at last reinvestment period, initiate settlement step
				reinvestment_state = false;
				settlement_state = true;
				settlement_count = settlement_delay;
			end

		elseif settlement_state	

			% countdown for settlement step
			settlement_count = settlement_count - 1;
			if settlement_count == 0
				% at last settlement period, terminate assignment step
				settlement_state = false;
			end

		else	% write new call

			% strike price is above stock price by the "cushion"
			strike_price = (1 + strike_cushion)*current_price;

			% strike prices in $1 increments for shares above $10 and $0.50 for shares below $10
			if current_price <= 10
				strike_price = ceil(2*strike_price)/2;
			else
				strike_price = ceil(strike_price);
			end

			% can use Black-Scholes option pricing formula for American option since no dividends
			dt = contract_expiration - current_time;
			current_call = gbm_call_price(current_price, strike_price, risk_free_rate, dt, sigma);

			% call price is rounded down to nearest $0.01
			current_call = floor(100*current_call)/100;

			% write call if call price is greater than contract cost
			if ~no_reinvestment && current_call > contract_cost
				current_cash = current_cash + current_shares*(current_call - contract_cost);
				current_strike = strike_price;
				assignment_state = false;
			end
		end
	else
		% covered position is not in assignment
		
		% check if call is at-the-money or in-the-money
		if current_price >= current_strike
			% The exercise probability is the probability that an assignment will occur during the
			% current subperiod of duration dt. Although various models can be formulated, assume
			% either a heuristic "moneyness" probability or a fixed uniform probability of exercise.

			dt = contract_expiration - current_time;

			% option has expired at- or in-the-money
			if dt <= 0
				% If option expires in-the-money, always exercise.
				exercise_probability = 1;
			else
				if isnan(exercise_likelihood)
					% Estimate probability of early exercise for next period (heuristic model). Compute
					% a "risk-free rate" probability based on risk-neutral arguments and compute a
					% "drift rate" probability based on diffusion arguments. Use the maximum of these
					% two alternatives.

					numer = log(current_price/current_strike) ...
						+ (max(risk_free_rate, mu) - 0.5*sigma^2)*dt;
					denom = 2*sigma*sqrt(dt);

					if contract_expiration == current_time
						exercise_probability = 1;
					else
						prob = 0.5*(1 + erf(numer/denom));
						exercise_probability = 1 - (1 - prob)^(tau/dt);
					end
				else
					% Based on a specified probability of early exercise between the start of the
					% investment period and option expiration, compute the probability of assignment for
					% the current subperiod.

					exercise_probability = 1 - (1 - exercise_likelihood)^(tau/dt);
				end
			end
			
			% check for assignment for this period and if assigned, start assignment process
			if rand() <= exercise_probability

				% initiate assignment process
				assignment_state = true;

				% initiate assignment confirmation step
				confirmation_state = true;
				confirmation_count = confirmation_delay;
			end
		end
	end
	
	% if option expires, shift to next contract
	if contract_expiration == current_time
		contract_expiration = next_contract_expiration;
		
		if current_price >= current_strike
			% if option is in-the-money at expiration, then if not in assignment, exercise option
			if ~assignment_state
				% initiate assignment process
				assignment_state = true;
				
				% initiate assignment confirmation step
				confirmation_state = true;
				confirmation_count = confirmation_delay;
			end
		end
	end
	
	% accrue interest on cash account at end of each day
	if mod(iter, periods_per_day) == 1			% note that period 1 happens outside loop
		current_cash = current_cash*(1 + risk_free_rate*tau*periods_per_day);
	end
	
	% update test variables
	if nargout > 2
		HC(iter) = current_shares;
		KC(iter) = current_strike;
		CC(iter) = current_cash;
		WC(iter) = current_cash + current_shares*current_price;
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
		HC(end) = current_shares;
		CC(end) = current_cash;
		WC(end) = current_cash + current_shares*X(end);
	end
end

% final scenario returns

% if initiating is true, then initiating a position so total return includes initial call premium
% otherwise, an ongoing position

if initiating
	rC = (current_cash + current_shares*X(end))/uncovered_initial_wealth - 1;
else
	rC = (current_cash + current_shares*X(end))/covered_initial_wealth - 1;
end
