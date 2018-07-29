%% Using Cook's Distance to Detect Outliers
% Copyright (c) 2011, The MathWorks, Inc.

% Create a vector of X values
clear all
clc
hold off

X = 1:100;
X = X';

% Create a noise vector
noise = randn(100,1);

% Create a second noise value where sigma is much larger
noise2 = 10*randn(100,1);

% Substitute noise2 for noise1 at obs# (11, 31, 51, 71, 91)
% Many of these points will have an undue influence on the model 

noise(11:20:91) = noise2(11:20:91);

% Specify Y = F(X)
Y = 3*X + 2 + noise;

% Cook's Distance for a given data point measures the extent to 
% which a regression model would change if this data point 
% were excluded from the regression. Cook's Distance is 
% sometimes used to suggest whether a given data point might be an outlier.

% Use regstats to calculate Cook's Distance
stats = regstats(Y,X,'linear');

% if Cook's Distance > n/4 is a typical treshold that is used to suggest
% the presence of an outlier
potential_outlier = stats.cookd > 4/length(X);

% Display the index of potential outliers and graph the results
X(potential_outlier)
scatter(X,Y, 'b.')
hold on
scatter(X(potential_outlier),Y(potential_outlier), 'r.')


