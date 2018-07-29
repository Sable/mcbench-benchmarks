%% Outlier demo
%Copyright (c) 2011, The MathWorks, Inc.

clear all
clc

% Generate a vector of X and Y variables
[CleanX, CleanY] = meshgrid(1:10);
CleanX = reshape(CleanX,100,1);
CleanY = reshape(CleanY,100,1);

%% Specify Z as a function of X and Y
A = 3; B = 4;
CleanZ = A*CleanX + B*CleanY;

%% Add in a noise vector
noise = 2*randn(100,1);
Noisy_Z = CleanZ + noise;

% Plot
scatter3(CleanX, CleanY, Noisy_Z, 'filled')
hold on

%% Predict Z as a function of X and Y
[foo gof] = fit([CleanX, CleanY], Noisy_Z, 'poly11')
plot(foo)

%% Use Robust Regression

bar = fit([CleanX, CleanY], Noisy_Z, 'poly11', 'Robust', 'LAR')

%% Use robustfit

b = robustfit([CleanX, CleanY], Noisy_Z)


