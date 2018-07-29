%% Model Exploration and Parameter Fitting
%
% Experiments are performed to test hypothesis and perform measurements of
% physical quantities.  Usually there is not a direct method to measure the
% physical quantity of interest, so instead a related quantity is measured
% and a model is used to relate the measured quantity to the underlying
% quantity of interest.
%
% In this lecture we continue on the theme of experimental data analysis.
% The MATLAB tools that are used for this purpose are well documented, 
% see Data Analysis >> Regression Analysis >> Programmatic Fitting 
% for a starting point.
%
% Also see help iofun, help audiovideo, help general from the MATLAB
% command line to find out about other functions that can be used to
% import and analyse data.
%
% Key points:
% 
% * Import of data
% * Fitting polynomials to data
% * Choosing an underlying model
% * Compare and fit models
% * Forecast and predict behaviour
%
%% Data fitting in MATLAB
%
% Once data has been obtained from an experiment (or simulation, or online
% database eg http://data.un.org) the next step is to analyse the data to
% look for trends or correlations between quantities.  The simplest way to
% do this is to fit a parameterised equation to the data, to determine the
% parameters that 'best' fit the data.  This can be done either from the
% MATLAB command line or using the figure plot tools.

%% Interactive fitting
%
% Once data has been plotted in MATLAB there are tools available directly
% from the figure window for performing analyses of the data.  Basic
% fitting of ploynomial curves or splines is accessible through the Tools
% >> Basic Fitting menu item
%
% See web([docroot '/techdoc/data_analysis/f1-15377.html']) for an example
% workflow.

load census
plot(cdate,pop,'ro')
xlabel('Year')
ylabel('Population')

%% Getting started with linear regression
% We need a programmatic way of performing the sort of least-squares
% line-fitting as carried out by the interactive tools. Firstly, we need
% some data - the following are experimental measurements of the surface
% tension of water, measured in Newtons / metre. The experimental data is
% stored in a CSV file
clear;
data = importdata( 'WaterSurfaceTension.csv', ',' );
T = data.data(:,1);
gamma = data.data(:,2);

% We can plot the relationship between T and gamma:
clf; 
plot( T, gamma, 'o' ); 
xlabel( 'T (K)' ); ylabel( '\gamma (N/m)' );

%% Creating the design matrix and fitting
% We want to fit a model of the form: gamma = a + b * T
% We can express this in a matrix form to include all our measurements:
% 
%   [ 1 T(1) ; * [ a ;  = [ gamma(1);
%     1 T(2) ;     b ]      gamma(2);
%     1 T(3) ;              gamma(3);
%     .....  ]              ....... ]
% 
%
%     A      *   X    = gamma

% Form the design matrix: a column of 1 and a column of T
A = [ ones(length(T),1), T ];

% Now we know A and gamma, and we want a least-squares solution
% for X. In MATLAB, this is simply:
X = A \ gamma %#ok - display the value of X

%% Adding the fitted line to the graph
% We can work forwards from X to give us the fitted straight line:
fitted_gamma = A * X;
hold on, plot( T, fitted_gamma, 'r-' ); hold off

%% Estimating errors in the fitted parameters
% Now that we've fitted parameters, we'd like to know the estimated errors
% in the fitted parameters. In MATLAB, we can do that by using "lscov",
% which calculates the standard errors in X:

[X, stdX] = lscov( A, gamma );

fprintf( 'gamma = (%.4g +/- %.2g) + T * (%.3g +/- %.2g)\n', ...
    X(1), stdX(1), X(2), stdX(2) );

%% Linear regression with non-polynomial terms
%
% The 'linear' in 'linear regression' does not mean that only a straight
% line can be fitted to the data.  Instead, it means that the fit function
% is a linear combination of a set of basis functions.  Each basis function
% is scaled by a certain value then all are added together to produce the
% fit function.  The values of these scaling parameters are the fit
% parameters.
%
% See web([docroot '/techdoc/data_analysis/f1-8450.html#f1-7306'])
% 
% This sort of fitting occurs quite often in physics, as many of the
% underlying physical models predict exponential or sinusoidal behaviour of
% the data.  An example is radioactive decay of a sample containing a
% mixture of two materials.
clear; clf;
% Enter t and y as columnwise vectors
t = [0 0.3 0.8 1.1 1.6 2.3]';
y = [0.6 0.67 1.01 1.35 1.47 1.25]';
plot( t, y, 'o' );

%% Fit the data
% We wish to fit: y = b(1) + b(2)*exp(-t) + b(3)*t*exp(-t), so
% form the design matrix
A = [ones(size(t))  exp(-t)  t.*exp(-t)];

% Calculate model coefficients
b = A\y;

T = (0:0.1:2.5)';
Y = [ones(size(T))  exp(-T)  T.*exp(-T)]*b;
clf, plot(T,Y,'-',t,y,'o'), grid on

%% Case study: Radioactive decay
% See analyseDecay.m example

%% Nonlinear fitting
%
% The underlying physical process generating the experimental data does not
% have to depend linearly on the model parameters.  Sometimes it is
% possible to transform the data so that the dependence is linear, for
% example taking the logarithm of an exponential process, but otherwise it
% becomes necessary to use a nonlinear fitting process.  There are several
% possiblities, a common one is to create a function of the model
% parameters and the data that has a minimum value when the model fits the
% data 'well'.  A complicating factor is that the fit function usually has
% several global minima as well as the overall global minima, so the
% initial guess of the model parameters may need to be close to the actual
% model parameters.
%
% In MATLAB it is possible to have the fit function be defined by a
% parameterised differential equation, that is then solved numerically for
% each set of candidate parameters.  This is a capability that many other
% analysis packages do not have readily available.

%% CASE STUDY: The pendulum experiment
%
% The purpose of this experiment is to determine the acceleration due to
% gravity at the earth's surface, g, by measuring the oscillation frequency
% of a pendulum.  To map the oscillation frequency to g we have a model of
% how we expect the pendulum to behave.  This is the simple harmonic
% oscillator model, which predicts how the experimental parameters, pendulum
% length and gravity, affect the period of oscillation of the pendulum.  In
% addition, there is another experimental parameter: the initial angle of
% the pendulum.  The simple harmonic oscillator model predicts that the
% initial angle should not affect the period of the pendulum motion...
%

%% Fitting model parameters to experimental data
% 
% First we simulate some data from a pendulum experiment.  In reality we
% would do the experiment and then input the data into a computer readable
% form eg by using the variable editor, Excel or writing to a text file and
% importing.  
clear, clf;
x0 = pi/2; % Radians from vertical
pendulumLength = 9.8/(2*pi)^2; 
noiseFactor = 0.05; % 1% noise
outFileNameAccurate = 'accuratePendulum.xls';
pendulumDataSimulated(x0, pendulumLength, noiseFactor, outFileNameAccurate);

% Read in the experimental data
res = readExperimentalData(outFileNameAccurate);
t = res.Time;
y = res.Position;

%% Plot the data including error bars

figure('Name','Experimental Data')
errorbar(t,y,noiseFactor*ones(size(t)),'b.')
title('Angle versus Time data')
xlabel('Time (s)')
ylabel('Angle')

%% Defining the model function
% 
% It looks like the pendulum motion is sinusoidal, so try fitting a cosine
% curve to the data to determine the frequency.
%
% To do fitting in MATLAB you need to create a model function to fit the
% data.  The model will depend on a number of parameters that will be
% determined by the fitting process.  Here we use a model function that
% consists of a cosine with amplitude, frequency and phase defined by the
% model parameters:

modelFun = @(t,param) param(1)*cos(param(2)*t + param(3));
% The above simply states that evaluating modelFun( t, [p_1, p_2, p_3] ) 
% results in: p_1 * cos( p_2 * t + p_3 ). We see that 
% p_2 corresponds to the angular frequency of the oscillation.

%% Defining the fit function
%
% To actually do the fitting to determine the model parameters we need
% another function that returns a scalar value representing the goodness of
% fit.  The MATLAB fit functions will determine the model parameters by
% minimising the value of this fit function.  The fit function we use here
% returns the norm of the difference between the observed data and the
% predicted value of the data at the measurement points.  

fitT = t( t < (max(t)/4) ); % truncated version of "t"
fitY = y( t < (max(t)/4) ); % similarly truncated "y"
fitFun = @(params) norm(fitY - modelFun(fitT,params));

initialParameterGuess = [1.5 2*pi 0];

fitParams = fminsearch(fitFun,initialParameterGuess);

%% Plot the data and fit to model, together with the residuals
figure('Name','Fitted data')

subplot(2,1,1)
tFitVals = linspace(min(t),max(t),1e4);
plot(t,y,'b.',tFitVals,modelFun(tFitVals,fitParams),'r-');
xlabel('Time')
ylabel('Angle')

% We calculate the value of "g" by remembering that the natural frequency
% of the pendulum in the small angle approximation is sqrt( g / len ), and
% the second fitted parameter corresponds to the angular frequency
titleStr = sprintf('Fitted experimental data: g = %f',...
    fitParams(2)^2*pendulumLength);
title(titleStr)

subplot(2,1,2)
plot(t,y - modelFun(t,fitParams),'b.-');
xlabel('Time')
ylabel('Residuals')


%% Modification of the model to explain more physics
% 
% The fit to the data shows that we infer g to be about 7m/s^2.  
% Is this correct?
%
% The discrepancy is because the approximation of the pendulum
% as being a simple harmonic oscillator is only appropriate at small
% angles, where $\sin\theta \approx \theta$.  The equation of motion
% for the pendulum is actually
%
% $\ddot{\theta} = \frac{g}{L}\sin\theta$
%
% which does not have a closed form solution.
%
% To accurately fit the data we construct a new fitness function that uses
% the exact dynamics to give the predicted behaviour for a given set of
% parameters.

newFitFun = @(params) pendulumFitFunction(t,y,params);

newInitialParamGuess = [sqrt(9.8/1); 1];

newFitParams = fminsearch(newFitFun,newInitialParamGuess);

%% Plot the new fit data

figure('Name','Fitted data')

subplot(2,1,1)
tFitVals = linspace(min(t),max(t),1e4);
[tout,yout] = pendulumDE(tFitVals,newFitParams(1), newFitParams(2));
plot(t,y,'b.',tFitVals,yout(:,1),'r-');
xlabel('Time')
ylabel('Angle')
titleStr = sprintf('Fitted experimental data: g = %f',...
    newFitParams(1)^2*pendulumLength);
title(titleStr)

subplot(2,1,2)
[tout,ypred] = pendulumDE(t,newFitParams(1), newFitParams(2));
plot(t,y - ypred(:,1),'b.-');
xlabel('Time')
ylabel('Residuals')


%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $
