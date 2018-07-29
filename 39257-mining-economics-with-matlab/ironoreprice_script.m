%% Simulating Iron Ore Prices
% This example demonstrates calibrating an geomtric brownian motion & 
% mean reverting stochastic model from historical data of iron ore prices.
% The model is then used to simulate the prices into the future using
% the Stochastic Differential Equation Simulation engine in Econometrics
% Toolbox.
% 
%% Import Historical Data
% Data is saved as a excel file based on historical iron ore prices from
% May 10, 2012 to June 22, 2012
% http://www.indexmundi.com/commodities/?commodity=iron-ore&months=240&currency=aud

% Database Version
importirondb
dates = data.Month;
Date = datenum(dates,'yyyy-mm-dd HH:MM:SS.FFF');
S = data.Price;

% Excel
% [data,txt] = xlsread('ironoremonthly.xlsx');
% dates = txt(3:end,1);
% Date = datenum(dates,'dd/mm/yyyy');
% S = data(:,1);
SR = S(2:end)./S(1:end-1) - 1;
%% The Models
% Return Model (gbm)
% The returns based model used for simulation Iron Orce Prices is geometric
% brownian motion.  It can be described as:
%
% $$ dX_t = \mu(t)X_t dt + D(t,X_t)V(t)dW_t $$
%
% $$ \mu = \textrm{ Instantaneous Rate of Return} $$
%
% $$ \sigma = \textrm { Volatility Rate} $$
%
% Mean Reversion Model (hwv)
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

%% Calibrate Parameters

modelsel = 'gbm'; %hwv - mean reverting, %gbm - based on returns
startdate = '2010-08-01';
i = find(datenum(startdate,'yyyy-mm-dd') == Date);
S2 = S(i:end);
Date2 = Date(i:end);
SR2 = SR(i+1:end);

switch modelsel
    case 'gbm'
        dt = 1;
        sigma = std(SR2);
        mu = mean(SR2);
        model = gbm(mu,sigma,'StartState', S(end));
    case 'hwv'
        % hwv - mean reversion model
        % The reversion rate and mean level can be calculated from the coefficients
        % of a linear fit between the prices and their first difference scaled
        % by the time interval parameter. All quantities are specified on an annual
        % scale.
        regressors = [ones(length(S2) - 1, 1) S2(1:end-1)];
        [coefficients, intervals, residuals] = regress(diff(S2), regressors);
        dt    = 1;
        speed = -coefficients(2)/dt;
        level = -coefficients(1)/coefficients(2);
        sigma =  std(residuals)/sqrt(dt);
        model = hwv(speed,level,sigma,  'StartState', S(end));
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

Ssim = Xsim;
SYear = Ssim(13:12:end,:);

% Visualize first 20 prices of 1000 paths
plot(Date, S, Date(end)+(0:30:(years*ann+1)*30-1), Ssim(:,1:100));
datetick; xlabel('Date'); ylabel('Iron Ore Price $US/tonne');
title('Historical & Simulated Iron Ore Prices')
%% Save Model
% The calibrated model is saved in a MAT-file for later use.

save ironoremodel model dt

%% Visual Analysis of Simulated Price Paths
% Instead of plotting a number of paths at once, we can plot longer single paths
% against the observed historical data to visually validate the simulated
% paths. This can serve as a final sanity check.

path = 15;
figure
plot(Date, S, 'b', Date(end)+(0:30:NSteps*30), Ssim(:,path), 'r');
title(['Historical & Simulated Prices, Path ' int2str(path)]);
datetick('x','keeplimits');
xlabel('Date'); ylabel('Iron Ore Price $US/tonne');
%% Histogram results of price paths at the end of each year

figure

for i = 1:years
    subplot(years/2,2,i)
    SsimM = mean(Ssim(i*12+1,:));
    hist(Ssim(i*12,:),20)
    hold on
    hm = plot(SsimM,0,'ro');
    title(['Year: ',num2str(i),' of Iron Ore Prices'])
    xlabel(['Iron Ore Price: Mean =',num2str(round(100*(SsimM))/100)])
    zlabel('Simulation Count')
end



