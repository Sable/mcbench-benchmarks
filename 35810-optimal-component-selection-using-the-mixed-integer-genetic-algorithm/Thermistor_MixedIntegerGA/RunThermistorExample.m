%% Find the Optimal Component Values for a Thermistor Circuit
% Copyright (c) 2012, MathWorks, Inc.
%
% This example problem motivated by EDN article “Genetic algorithm solves 
% thermistor-network component values”, EDN, March 19, 2008
%% Temperature and Voltage Data
Tdata = -40:5:85;
Vdata = 1.026E-1 + -1.125E-4 * Tdata + 1.125E-5 * Tdata.^2;

%% Plot the Desired Curve
plot(Tdata,Vdata,'-*');
title('Target Curve','FontSize',12); 
xlabel('Temperature (^oC)'); ylabel('Voltage (V)')

%% Load in Standard Component Values
load('StandardComponentValues.mat')

%% Inspect first 15 Resistor Values
disp('Sample of Available Resistor Sizes:')
disp(Res(1:15));

%% Sample Temperature Curve for arbitrary indices
Vnew = voltageCurve(Tdata, [2 2 2 2 1 1], Res, ThVal, ThBeta);

%% Add New Curve to Plot
hold on; plot(Tdata,Vnew,'-or');

%%
% We would like to find the optimal indices that result in a temperature
% curve closest to our desired curve.  Our initial guess of [2 2 2 2 1 1]
% did not yield a good fit, and there are 70*70*70*70*9*9 = 1944810000
% different possible combinations for this circuit.  We will use an
% optimization routine, the Genetic Algorithm, to find the optimal indices
% for our problem.  The Genetic Algorithm allows us to constrain values to
% be integers, which is necessary for this problem since indices into a
% vector must be integers.  

%% Bounds on our Vector of Indices
lb = [1 1 1 1 1 1];
ub = [70 70 70 70 9 9];

%% Constrain All 6 Variables to be Integers
intCon = 1:6;

%% Create Handle to Custom Output Function
custOutput = @(a1,a2,a3)ThOptimPlot(a1,a2,a3,Tdata,Vdata,Res,ThVal,ThBeta);

%% Set Options for Optimization
options = gaoptimset('CrossoverFrac',0.5,'PopulationSize',100,...
    'StallGen',125,'Generations',150,...
    'PlotFcns',@gaplotbestf,'OutputFcns',custOutput);

%% Run the Genetic Algorithm
% Note: The Genetic Algorithm is based on stochastic methods, meaning that
% we are not guaranteed to find the same solution every time.  To reproduce
% the exact results from the video, run "rng(45)" at the Command Line to 
% set the same seed for the random number generator.

[xOpt,fVal] = ga(@(x)objectiveFunction(x,Res,ThVal,ThBeta,Tdata,Vdata),...
    6,[],[],[],[],lb,ub,[],intCon,options);

%% Inspect the Solution Vector to see that All Values are Integers
disp('Integer Solution Returned by GA:')
disp(xOpt)
