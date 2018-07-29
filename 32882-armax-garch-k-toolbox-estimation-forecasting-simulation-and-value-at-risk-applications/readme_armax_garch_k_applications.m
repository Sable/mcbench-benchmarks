%% Applications 
% The following examples will guide you through some of the functionality built in this toolbox. 
% Specifically, how to estimate the GARCH-K model, forecast and simulate.
%
% The data used for the examples are daily prices of the FTSE 100 index for
% the period from 03/01/2000 to 31/12/2010, which is available from finance.yahoo.com.

clc
clear
% Import of data
load('data.mat');
% Estimate the continious returns of the series
data = price2ret(levels,[],'Continuous');
% Convert the dates to serial date number
dates = datenum(cell2mat(levelsdates(3:end)), 'dd/mm/yyyy');

% Plot the levels and returns of FTSE 100
figure
subplot(2,1,1), plot(dates,levels(2:end,1)); datetick('x','yyyy','keepticks'); xlim([dates(1), dates(end)]); title('FTSE 100');xlabel('Time'); ylabel('Levels');
subplot(2,1,2), plot(dates,data(:,1)); datetick('x','yyyy','keepticks'); xlim([dates(1), dates(end)]); title('FTSE 100 (Returns)'); xlabel('Time'); ylabel('Returns');
set(gcf,'Position',[100,100,900,600])
snapnow;
close(gcf)

% Some other options
warning('off', 'MATLAB:nearlySingularMatrix');

%% Estimating GARCH models
% This example illustrates how to estimate the ARMAX(1,1,0)-GARCH(1,1)-K(1,1) model using the garchk function, as well as plot the FTSE 100, its
% estimate variance, kurtosis and residuals using the garchkplot function. The inputs are the GARCH-K model AR, MA, GARCH and ARCH. The outputs contain the 
% estimated parameters, standard errors, value of the loglikelihood function, conditional variance, kurtosis, residuals and summary 
% of a variety of statistics such as robust standard errors and scores, among others.
[parameters, stderrors, LLF, ht, kt, nu, resids, summary] = garchk(data(:,1), 'GARCH', 1,1,0,1,1,0, [], options);
%%
garchkplot(data(:,1),ht,kt,resids)


%% Forecasting Volatility
% The garchkfor and garchkfor2 functions are applied to forecast the mean and volatility processes. The inputs of the 
% functions are the GARCH model, the number of forecasted periods. The difference between the two functions 
% is that the former estimates the GARCH model whereas the later passes the already estimated parameters to the function.
% In this example we  will forecast 10 days ahead using the ARMAX(1,1,0)-GARCH(1,1,0)-K(1,1) model. The mean, volatility 
% and kurtosis forecasts will be saved in the MF, VF and KF vectors, and the cumulative (or multiperiod holdings) mean and volatility 
% forecasts in MC and VC respectively:
[MF, VF, KF, MC, VC] = garchkfor2(data(:,1), resids, ht, kt, parameters, 'GARCH',1,1,1,1,10);
[MF, VF, KF, MC, VC]

%% Estimating Value-at-Risk
% The garchkvar and garchkvar2 functions are applied to estimate Value-at-Risk for for both long and short positions.
% The inputs of the functions are GARCH model the number of forecasted periods and a% losses. 
% The VaR is estimated as:
%
% $$VaR_t = {\widehat{\mu}_{t+n}}+{\Phi}(a)^{-1}{\widehat{\sigma}_{t+n}}$
%
% where:
%
% $${\widehat{\mu}_{t+n}}, \ is \ a \ forecast \ of \ the \ conditional \ mean$
% $${\Phi}(a)^{-1}, \ the \ corresponding \ quantile \ of \ the \ assumed \ time \ varying \ Student \ t \ distribution$
% $${\widehat{\sigma}_{t+n}}, \ is \ a \ forecast \ of \ the \ conditional \ volatility$.
%
% In this exampe we will forecast 10 days ahead 99% VaR estimates using the ARMAX(0,0,0)-GARCH(1,1,0)-K(1,1) model 
% The long  and short positions will be saved in the VaR variable:
VaR99 = garchkvar2(data(:,1),resids, ht, kt, parameters, 'GARCH', 1, 1, 1, 1, 10, 0.99);
VaR99

%% GARCH Simulation
% The garchsim function is applied to simulate volatility, kurtosis and returns series. It's inputs are the GARCH parameters, 
% model,nthe ARCH and GARCH effects, number of samples and number of paths. Additionally a vector of 
% time series of positive pre-sample conditional standard deviations and kurtosis may be provided, which the model
% will be conditioned. Make sure however that these vectors have sufficient observations in order to initialize the 
% conditional variance and kurtosis processes. The outputs are a vector of simulated returns with GARCH variances, kurtosis and a vector of 
% conditional standard deviations. In this example we will simulate 5 paths of 100 days ahead based on the volatility 
% estimate at date 13/08/2010 (i.e. 100 days before the end of the sample) of the ARMAX(0,0,0)-GARCH(1,1)-K(1,1) model. 
% Then plot the realized and simulated returns, conditional variances and conditional kurtosis. 
options.OutputResults = 'off';
[parameters, stderrors, LLF, ht, kt, nu, resids, summary] = garchk(data(1:end-100,1), 'GARCH', 1,1,0,1,1,0, [], options);
[Returns, Sigmas, Kurtosis] = garchksim(parameters, 'GARCH', 1, 1, ht, kt, 0, 100, 5);

holder1=nan(size(data(:,1),1),5);
holder1(end-99:end,:) = Returns;

figure
subplot(3,1,1),plot(dates(end-200:end),holder1(end-200:end,1:3),'DisplayName','Simulated Returns'); hold all; plot(dates(end-200:end),data(end-200:end,1),'DisplayName','Returns'); hold all;hold off;figure(gcf);datetick('x','mm-yyyy','keepticks'); xlim([dates(end-200), dates(end)]); title('Realized vs Simulated Returns'); xlabel('Time'); ylabel('Returns');
subplot(3,1,2),plot(dates(end-99:end),Sigmas,'DisplayName','Simulated Variables'); datetick('x','mm-yyyy','keepticks'); xlim([dates(end-99), dates(end)]); title('Simulated Conditional Variances'); xlabel('Time'); ylabel('Conditional Variance');
subplot(3,1,3),plot(dates(end-99:end),Kurtosis,'DisplayName','Simulated Kurtosis'); datetick('x','mm-yyyy','keepticks'); xlim([dates(end-99), dates(end)]); title('Simulated Conditional Kurtosis'); xlabel('Time'); ylabel('Conditional Kurtosis');
set(gcf,'Position',[100,100,900,600])
snapnow;
close(gcf)

%% <..\readme\readme.html Return to Main>