function analyseExperimentalData(inFileName)
% analyseExperimentalData : 

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $

% Read in the data from an Excel spreadsheet and return a structure
% containing the Position, Velocity, Time at which measurements were taken,
% and Energy.  Here the Position and Velocity are actually angular position
% and angular velocity.
res = readExperimentalData(inFileName);

% Plot the time series data.
subplot(2,2,1)
plot(res.Time, res.Position, 'b.')
xlabel('Time (s)');
ylabel('Position');

% Plot the phase space plot of velocity and position on the same plot.
subplot(2,2,3)
% Fit an elipse to the data:
% The equation of an ellipse is x.^2/a^2 + y.^2/b^2 = 1
% In matrix form this is [x, y]*[1/a^2; 1/b^2] = [1; 1; 1; 1; ...] 
% where x and y are column vectors.
% We hence want to solve the equation A*x = d, where A is the [x,y] Nx2
% matrix, x is the column vector [c0; c1] and d is the column
% vector of 1s.  This is done using the backslash operator: x = A\d
% The fit parameters are related to the ellipse parameters by
% c0 = 1/a^2, c1 = 1/b^2.
% The line below fits an ellipse to the experimental data.
ellipseParams = [res.Position.^2, res.Velocity.^2]\ones(size(res.Position));

% Once we have the parameters of the ellipse use these to construct a fit
% curve to plot on top of the data.
thetaVals = linspace(0, 2*pi, 1e4);
posValsFit = sqrt(1/ellipseParams(1))*cos(thetaVals);
velValsFit = sqrt(1/ellipseParams(2))*sin(thetaVals);

% Plot the phase space picture of the experimental data, ie position and
% velocity on the same plot.  Also plot the fit to the data.
plot(res.Position, res.Velocity,'b.',posValsFit,velValsFit,'g-')
xlabel('Position')
ylabel('Velocity')
axis square 

% Try to fit the data - only consider first oscillation.  This is estimated
% to be about an 1/8th of the total simulation time (since we know that the
% input data in this example comes from a simulation that goes for 10
% periods of oscillation - see pendulumSimulation).  For real data the
% estimated period would be passed in as a parameter of the function.
maxTime = max(res.Time);
firstCycleIndex = res.Time < maxTime/8;

% Define the model function to fit: here we are assuming the motion is
% sinusoidal, and are attempting to fit the amplitude and frequency of the
% motion.  We could also have the phase of the motion as a third model
% parameter, however for this example we assume the motion starts from a
% position of maximum displacement, implying motion of the form
% A*cos(2*pi*f*t).
% The model function is defined by a vector of model parameters,
% [amplitude; freqency] in this case, and the time that the model is
% evaluated.
modelFun = @(modelParams,t) modelParams(1)*cos(2*pi*modelParams(2)*t);

% Define the fitness function based on the model function and the data.
% For each time value where a measurement has been taken we calculate the
% predicted position using the model function, then calculate the
% difference between this predicted value and the actual measured value of
% the position at this time.  The error in the fit is then defined as the
% square root of the sum of the squares of these error terms (calculated
% here using the 'norm' function).
fitFun = @(x) norm(res.Position(firstCycleIndex) - ...
    modelFun(x, res.Time(firstCycleIndex)));

% Guess at the fit parameters, assume the amplitude is the maximum position
% encountered in the data.
initialParamGuess = [max(abs(res.Position)); 0.7/(max(res.Time)/10)];

% Set options for the optimization, here just set display of the fit
% progress to 'none'.
options = optimset('Display','none');

% The line below performs the fit and returns the parameters giving the
% best fit.
fitParams = fminsearch(fitFun, initialParamGuess, options);

% Plot the data and the fitted curve
subplot(2,2,[2 4]) % Make this subplot take up the right hand side of the figure.
% Define a vector of times at which to evaluate the fit function.
fitTimeVals = linspace(0, maxTime, 1000)';
% Plot the original data and the fit to this data.
plot(res.Time, res.Position, 'b.',...
    fitTimeVals, modelFun(fitParams, fitTimeVals),'r-'); % ,...
%     res.Time,modelFun(initialParamGuess,res.Time),'g--')
% Title the sub-plot with the fit parameters.
title(['Amplitude = ', num2str(fitParams(1)), ...
    ' Frequency = ', num2str(fitParams(2)), 'Hz'])
