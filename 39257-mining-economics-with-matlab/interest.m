function [simIR,discFactorY] = interest(years,NTrials,steps)
[ir,txt] = xlsread('ausinterestrates.xls','A4000:B9177');

dates = datenum(txt,'dd/mm/yyyy');

regressors = [ones(length(ir) - 1, 1) ir(1:end-1)];
[coefficients, intervals, residuals] = regress(diff(ir), regressors);
dt    = 1;  
speed = -coefficients(2)/dt;
level = -coefficients(1)/coefficients(2);
sigma =  std(residuals)/sqrt(dt);

% Create an HWV object with an initial StartState 
% set to the most recently observed short rate.

irObj = hwv(speed, level, sigma, 'StartState', ir(end));

t = steps*years;
X = simulate(irObj, t-1, 'NTrials', NTrials);
simIR = squeeze(X);
% Calculating discount factor based off the mean of all simulations
r = mean(simIR,2)/100; 
c = 0.07;
discFactor = exp(-(r+c).* (1:size(simIR,1))'/252);
discFactorY = discFactor(252:252:end);