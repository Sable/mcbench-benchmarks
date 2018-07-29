function [Date,SYear,Ssim] =  ironoreprice(years,NTrials,steps,model,start)

%% Import Historical Data
% The data can either be imported from a MAT-file or from the database using
% the auto-generated fetch function. The data set contains spot prices for natural
% gas at Henry Hub from 2000 to 2008


% importirondb
% dates = data.Month;
% Date = datenum(dates,'yyyy-mm-dd HH:MM:SS.FFF');
% S = data.Price;
% Excel
[data,txt] = xlsread('ironoremonthly.xlsx');
dates = txt(3:end,1);
Date = datenum(dates,'dd/mm/yyyy');
S = data(:,1);
SR = S(2:end)./S(1:end-1) - 1;

%% The Model
% The model used for simulating the Iron Ore prices is an Ornstein-Uhlenbeck
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

%% Calibrate Parameters
% The reversion rate and mean level can be calculated from the coefficients
% of a linear fit between the prices and their first difference scaled
% by the time interval parameter. All quantities are specified on an annual
% scale. 

modelsel = char(model); %hwv - mean reverting, %gbm - based on returns
if start<700000
    startdate = start+693960;
else
    startdate = start;
end
i = find(startdate == Date);
S2 = S(i:end);
Date2 = Date(i:end);
SR2 = SR(i+1:end);

switch modelsel
    case 'hwv'
        %hwv
        regressors = [ones(length(S2) - 1, 1) S2(1:end-1)];
        [coefficients, intervals, residuals] = regress(diff(S2), regressors);
        dt    = 1;
        speed = -coefficients(2)/dt;
        level = -coefficients(1)/coefficients(2);
        sigma =  std(residuals)/sqrt(dt);
        % Create an Ornstein-Uhlenbeck mean reverting drift model
        % An Ornstein-Uhlenbeck model is a special case of a Hull-White-Vasicek
        % model with constant volatility. The HWV constructor is used to setup an
        % SDE model with the parameters estimated above. The start state of the
        % model is set to the last observed log closing price. This model can be
        % easily extend to accommodate the forward curve and option prices by
        % setting the meanLevel and volatility parameters to be functions of time.
        model = hwv(speed,level,sigma,  'StartState', S(end))
    case 'gbm'
        dt = 1;
        sigma = std(SR2);
        mu = mean(SR2);
        model = gbm(mu,sigma,'StartState', S(end))
end


%% Monte-Carlo Simulation
% The model defined above can be simulated with the simulate method of the
% SDE object to generate multiple log price paths. These are exponentiated
% to compute the simulated natural gas prices. The plot below shows 1000
% paths simulated daily, 8 years into the future.

NTrials = 1000;
years = 8;
ann = 12;
NSteps  = years*ann;

tic
Xsim = simulate(model, NSteps, 'NTrials', NTrials, 'DeltaTime', dt);
Xsim = squeeze(Xsim); % Remove redundant dimension
toc

Ssim = Xsim; %HWV
SYear = Ssim(13:12:end,:);
