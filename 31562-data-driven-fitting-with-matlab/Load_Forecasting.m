%% Data Driven Fitting with High Dimensional Data
% Copyright (c) 2011, The MathWorks, Inc.

%% Format my data

% Clean Up
clear all
clc

% Import my data
ds = dataset('xlsfile', 'EnergyData.xlsx');

% plot Load = f(time)

plot(ds.SystemLoad(1:336))

%% Divide my data into a test set and a training set
% 2004 - 2007 = training set
% 2008 = test set

[yr, mo, da] = datevec(ds.Date);

Test = ds(yr == 2008, :);
Training = ds(yr ~= 2008, :);

Training_Y = Training.SystemLoad;
Training_X = double(Training(:,3:end));


%%  Create a Load Forecasting Model using a Boosted Decision Tree

t = RegressionTree.template('Surrogate','on');

rens = fitensemble(Training_X, Training_Y, 'LSBoost', 1000, t, ...
    'CategoricalPredictors', [3 4 5],...
    'PredictorNames', Training.Properties.VarNames(3:end))

%% Generate Predictions from the test set

% Create a test set
Test_Y = Test.SystemLoad;
Test_X = double(Test(:,3:end));

% Generate Predictions
Forecast_Load = predict(rens,Test_X);

% Use a simple chart to show predicted versus actual for two weeks of data
figure
plot(Test_Y(1:336), 'b');
hold on
plot(Forecast_Load(1:336), 'r');

%  Use a scatter plot to show Predicted versus Residuals
figure

scatter(Test_Y, Forecast_Load - Test_Y, '.', 'r');
refline(0,1)
xlabel('Predicted')
ylabel('Residuals')

%% Inspect some of the methods associated with "rens"

methods(rens)

display = dataset;
display.Variable = rens.PredictorNames';
display.Importance = predictorImportance(rens)';
sortrows(display, 'Importance', 'descend')

loss(rens, Training_X, Training_Y)

%%  Evaluate Goodness of Fit

% Errors = Predicted - observed
Errors = predict(rens,Test_X) - Test_Y;

% Inspect the Errors
figure
histfit(Errors)
figure
normplot(Errors)

%%  Segment the data into groups

% By Hour
figure;
boxplot(Errors, Test.Hour, 'plotstyle', 'compact');
xlabel('Hour'); ylabel('Errors');
title('Breakdown of Errors by hour');

% By Weekday
figure
boxplot(Errors, Test.Weekday, 'labels', {'Sun','Mon','Tue','Wed','Thu','Fri','Sat'});
ylabel('Percent Error Statistics');
title('Breakdown of Errors by weekday');

% By Month
figure
boxplot(Errors, datestr(Test.Date,'mmm'));
ylabel('Percent Error Statistics');
title('Breakdown of Errors by month');


%%  Use Industry Specific Error Metrics

Error_Percentage = (abs(Errors)./Test_Y) * 100;

fL = reshape(Forecast_Load, 24, length(Forecast_Load)/24)';
tY = reshape(Test_Y, 24, length(Test_Y)/24)';
peakerrpct = abs(max(tY,[],2) - max(fL,[],2))./max(tY,[],2) * 100;

MAE = mean(abs(Error_Percentage));
MAPE = mean(Error_Percentage(~isinf(Error_Percentage)));

fprintf('Mean Absolute Percent Error (MAPE): %0.2f%% \nMean Absolute Error (MAE): %0.2f MWh\nDaily Peak MAPE: %0.2f%%\n',...
    MAPE, MAE, mean(peakerrpct))

%%  Switch algorithms

tic
rens2 = fitensemble(Training_X, Training_Y, 'Bag', 100, 'Tree', ...
    'type', 'regression',...
    'CategoricalPredictors', [3 4 5],...
    'PredictorNames', Training.Properties.VarNames(3:end))
toc

%%  Contrast Models

Forecast_Load2 = predict(rens2,Test_X);

% Use a simple chart to show predicted versus actual for two weeks of data
plot(Test_Y(1:336), 'b');
hold on
plot(Forecast_Load(1:336), 'r');
plot(Forecast_Load2(1:336), 'k');

residuals2 = Forecast_Load2 - Test_Y;

figure
histfit(residuals2)

Error_Percentage2 = (abs(residuals2)./Test_Y) * 100;

fL2 = reshape(Forecast_Load2, 24, length(Forecast_Load2)/24)';
peakerrpct2 = abs(max(tY,[],2) - max(fL2,[],2))./max(tY,[],2) * 100;

MAE2 = mean(abs(Error_Percentage2));
MAPE2 = mean(Error_Percentage2(~isinf(Error_Percentage2)));

fprintf('Mean Absolute Percent Error (MAPE):  %0.2f%% \nMean Absolute Error (MAE): %0.2f MWh\nDaily Peak MAPE: %0.2f%%\n',...
    MAPE, MAE, mean(peakerrpct))

fprintf('Mean Absolute Percent Error 2: (MAPE): %0.2f%% \nMean Absolute Error 2 (MAE): %0.2f MWh\nDaily Peak MAPE 2: %0.2f%%\n',...
    MAPE2, MAE2, mean(peakerrpct2))

%% Neural Network

tic

net = newfit(Training_X', Training_Y', 20);
net.performFcn = 'mae';
net = train(net, Training_X', Training_Y');

toc

Forecast_Load3 = sim(net, Test_X')';

% Use a simple chart to show predicted versus actual for two weeks of data
figure
plot(Test_Y(1:336), 'b');
hold on
plot(Forecast_Load(1:336), 'r');
plot(Forecast_Load2(1:336), 'k');
plot(Forecast_Load3(1:336), 'm');

residuals3 = Forecast_Load3 - Test_Y;

figure
histfit(residuals3)

Error_Percentage3 = (abs(residuals3)./Test_Y) * 100;

fL3 = reshape(Forecast_Load3, 24, length(Forecast_Load3)/24)';
peakerrpct3 = abs(max(tY,[],2) - max(fL3,[],2))./max(tY,[],2) * 100;

MAE3 = mean(abs(Error_Percentage3));
MAPE3 = mean(Error_Percentage3(~isinf(Error_Percentage3)));

fprintf('Mean Absolute Percent Error (MAPE): %0.2f%% \nMean Absolute Error (MAE): %0.2f MWh\nDaily Peak MAPE: %0.2f%%\n',...
    MAPE, MAE, mean(peakerrpct))

fprintf('Mean Absolute Percent Error 2 (MAPE): %0.2f%% \nMean Absolute Error 2 (MAE): %0.2f MWh\nDaily Peak MAPE 2: %0.2f%%\n',...
    MAPE2, MAE2, mean(peakerrpct2))

fprintf('Mean Absolute Percent Error 3 (MAPE): %0.2f%% \nMean Absolute Error 3 (MAE): %0.2f MWh\nDaily Peak MAPE 3: %0.2f%%\n',...
    MAPE3, MAE3, mean(peakerrpct3))




