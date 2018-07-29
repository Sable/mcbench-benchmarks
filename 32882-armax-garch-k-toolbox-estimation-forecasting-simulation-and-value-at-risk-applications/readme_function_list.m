%% Function List
%
%% ARMAX-GARCH Toolbox
%
% <matlab:web(fullfile('garch.m')) garch.m>, estimates the ARMAX-GARCH family of models
% 
% Inputs: a data vector, the GARCH model to be estimated, the distribution, the order of AR, MA, ARCH and GARCH effects as well as a vector of factors for the mean and volatility process. 
% 
% Outputs: a vector of estimated parameters, standard errors estimated by the inverse Hessian, the Log-Likelihood value, a vector of conditional variances, a vector of residuals, and a summary of results which includes: model statistics, t-statistics, robust standard errors, scores among others. 
%
% <matlab:web(fullfile('garchfind.m')) garchfind>, finds the combination of models and distributions that better fits the data based on a set of criteria (i.e. largest log likelihood value and the smallest AIC and BIC criteria).
%
% Inputs: a data vector, a model and distribution vectors, the order of AR, MA, ARCH and GARCH,
%
% Outputs: the best fit model
%
% % <matlab:web(fullfile('garchplot.m')) garchplot>, Plots the data,volatility and residuals
%
% <matlab:web(fullfile('garchfor.m')) garchfor> & <matlab:web(fullfile('garchfor2.m')) garchfor2>, estimates mean, volatility and kurtosis forecasts
% 
% Inputs: a data vector, a vector of residuals, a vector of conditional variances, a set of parameters, the  model, the order of AR, MA, ARCH and GARCH and the number of forecasts
% 
% Outputs: a vector of mean, and volatility forecasts as well as a vector of cumulative mean and volatility forecasts.
%
% <matlab:web(fullfile('garchsim.m')) garchsim>, simulates GARCH responses 
%
% Inputs: estimated parameters, GARCH model, distribution, order of ARCH and GARCH, number of samples and number of paths. Additionally, a vector of time series of positive pre-sample conditional standard deviations may be provided, which the variance model will initialize.
%
% Outputs: a vector of simulated series and conditional standard deviations
%
% <matlab:web(fullfile('garchvar.m')) garchvar> & <matlab:web(fullfile('garchvar2.m')) garchvar2>, estimates  Value-at-Risk for a given confidence level and horizon period for both long and short positions
%
% Inputs: a data vector, a vector of residuals, a vector of conditional% variances, a set of parameters, the  model, the distribution, the order of AR, MA, ARCH and GARCH, the number of forecasts and confidence level
%
% Outputs: a vector of VaR forecasts
%
% <matlab:web(fullfile('garchvolfor.m')) garchvolfor>, an application in Volatility Forecasting & Value-at-Risk. It allows the comparison of volatility and Value-at-Risk estimates for a data vector and for a variety of GARCH models and distributions as specified in the model & distribution variables and at different forecast periods as well as sort the results according to only a sub-set of forecast periods. 
%
% Inputs: a data vector, a vector of models and distributions, order of AR, MA, ARCH and GARCH, max forecasts, the forecasts of interest and a vector of a% VaR losses
%
% Outputs:  volatility and VaR back-testing results, vectors of forecasted estimated of volatility, VaR and returns
%
%% ARMAX-GARCH-K Toolbox
%
% <matlab:web(fullfile('garchk.m')) garchk>, estimates the ARMAX-GARCH-K family of models
%
% Inputs: a data vector, the GARCH model to be estimated, the order of AR, MA, ARCH and GARCH effects as well as a vector of factors for the mean and volatility process. 
%
% Outputs: a vector of estimated parameters, standard errors estimated by the inverse Hessian, the Log-Likelihood value, a vector of conditional variances, a vector of conditional kurtosis, a vector of residuals, and a summary of results which includes: model statistics, t-statistics, robust standard errors, scores among others. 
%
% <matlab:web(fullfile('garchkplot.m')) garchkplot>, Plots the data, conditional volatility, conditional kurtosis and residuals
%
% <matlab:web(fullfile('garchkfor.m')) garchkfor> & <matlab:web(fullfile('garchkfor2.m')) garchkfor2>, estimates mean, volatility and kurtosis forecasts
%
% Inputs: a data vector, a vector of residuals, a vector of conditional variances, a vector of conditional kurtosis, a set of parameters, the  model, the order of AR, MA, ARCH and GARCH and the number of forecasts
%
% Outputs: a vector of mean, volatility and kurtosis forecasts as well as a vector of cumulative mean and volatility forecasts.
%
% <matlab:web(fullfile('garchksim.m')) garchksim>, simulates volatility and kurtosis responses 
%
% Inputs: estimated parameters, GARCH model, distribution, order of ARCH and GARCH, number of samples and number of paths. Additionally, a vector of time series of positive pre-sample conditional standard deviations may be provided, which the variance model will initialize.
%
% Outputs: a vector of simulated series, conditional standard deviations and conditional kurtosis
%
% <matlab:web(fullfile('garchkvar.m')) garchkvar> & <matlab:web(fullfile('garchkvar2.m')) garchkvar2>, estimates  Value-at-Risk for a given confidence level and horizon period for both long and short positions
%
% Inputs: a data vector, a vector of residuals, a vector of conditional variances, a set of parameters, the  model, the order of AR, MA, ARCH and GARCH, the number of forecasts and confidence level
%
% Outputs: a vector of VaR forecasts
%
% <..\readme\readme.html Return to Main>


 









