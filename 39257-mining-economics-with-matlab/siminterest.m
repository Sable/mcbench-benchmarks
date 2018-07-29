%http://www.rba.gov.au/statistics/tables/index.html#interest_rates

% [data,txt] = xlsread('ausinterestrates.xls','A7387:B9177');
[ir,txt] = xlsread('ausinterestrates.xls','A4000:B9177');

dates = datenum(txt,'dd/mm/yyyy');
figure
plot(dates,ir);
datetick('x','keepticks')

regressors = [ones(length(ir) - 1, 1) ir(1:end-1)];
[coefficients, intervals, residuals] = regress(diff(ir), regressors);
dt    = 1;  
speed = -coefficients(2)/dt;
level = -coefficients(1)/coefficients(2);
sigma =  std(residuals)/sqrt(dt);

% Create an HWV object with an initial StartState 
% set to the most recently observed short rate.

irObj = hwv(speed, level, sigma, 'StartState', ir(end));

y = 8;
t = 252*y;
NTrials = 1000;
X = simulate(irObj, t-1, 'NTrials', NTrials);
simIR = squeeze(X);


figure
plot(mean(simIR, 2)); xlabel('Daily'); ylabel('Interest Rate'); 
title('Simulated Interest Rate');

figure
plot(simIR(:,3)); xlabel('Daily'); ylabel('Interest Rate'); 
title('Simulated Interest Rate');

r = mean(simIR,2)/100;
c = 0.07;
discFactor = exp(-(r+c).* (1:size(simIR,1))'/252);
discFactorY = discFactor(252:252:end);

