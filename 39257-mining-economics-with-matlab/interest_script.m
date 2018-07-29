%% Interest Rate model
% Based on Mean Reverting SDE (hwv)
% The mean reversion model used for simulating the Iron Ore prices is an Ornstein-Uhlenbeck
% brownian motion with mean reverting drift. This model is fit to the prices
% iron ore prices. The discrete-time equation of this model can be written as,
%
% $$ \Delta x_t = \alpha(\mu - x_t)\Delta t + \sigma dz_t, \textrm{ where } dz_t \sim N(0, \sqrt\Delta_t) $$
%
% $$ \alpha = \textrm{ Mean Reversion Rate}$$
%
% $$ \mu = \textrm{ Mean level} $$
%
% $$ \sigma = \textrm { Volatility } $$

%% Import Historical Data
% Interest rates used are based off Australia historical values:
% http://www.rba.gov.au/statistics/tables/index.html#interest_rates

% Importing data from 19/12/91 until 22/06/2012
[ir,txt] = xlsread('ausinterestrates.xls','A4000:B9177');

% Plotting historial interest rates
dates = datenum(txt,'dd/mm/yyyy');
figure
plot(dates,ir);
title('Historical Australian Interest Rates')
xlabel('Date')
ylabel('Interest Rates')
datetick('x','keepticks')

%% Mean Reversion Model 

% Calculating coefficients for the model
regressors = [ones(length(ir) - 1, 1) ir(1:end-1)];
[coefficients, intervals, residuals] = regress(diff(ir), regressors);
dt    = 1;  
speed = -coefficients(2)/dt;
level = -coefficients(1)/coefficients(2);
sigma =  std(residuals)/sqrt(dt);

% Creating a mean reversion model using the HWV SDE object 
irObj = hwv(speed, level, sigma, 'StartState', ir(end));

%% Simulating Interest Rates
y = 8; %no of years
t = 252*y; %252 working days in a year
NTrials = 1000;
X = simulate(irObj, t-1, 'NTrials', NTrials);
simIR = squeeze(X);


figure
plot(mean(simIR, 2)); xlabel('Daily'); ylabel('Interest Rate'); 
title('Mean Level of Australian Interest Rates Simulations')
xlabel('Days')
ylabel('Interest Rates')
title('Simulated Interest Rate');

figure
stairs(simIR(1:30:end,3)); xlabel('Daily'); ylabel('Interest Rate'); 
title('Path 3 of Monthly Australian Interest Rates Simulations')
xlabel('Months')
ylabel('Interest Rates')
title('Simulated Interest Rate');



