% analyseDecay : analyse exponential decay to determine decay rate

%% Start by setting up some parameters
clear, clf;
% Sample for 60 seconds at most
sampleTime = 60; % s
% Return 100 000 decaytimes
sampleCount = 1e6;
% Half-lives of the isotopes in minutes
halfLives = [0.2 2];
% Relative abundances of the isotopes
relativeAmount = [2 4];

%% Generate the simulated decay times
% decayTimes is an array of times at which decay events are observed - the
% times at which our Geiger count clicks.
decayTimes = generateDecayData(sampleTime,sampleCount,halfLives,...
    relativeAmount);

%% Calculate the histogram of number of decays versus time
% We chunk the decayTimes into several "bins" of time, so that we can
% calculate the decay rate of all types of isotope
[binEdges,decayRate] = decayHistogram(decayTimes);

%% Plot the histogram data
figure(1);
subplot(2,1,1)
plot(binEdges,decayRate,'b.')
ylabel('decayRate')
xlabel('t (s)')
subplot(2,1,2)
plot(binEdges,log(decayRate),'b.')
ylabel('log(decayRate)')
xlabel('t (s)')

%% Fit the data using a linear fit to the log of the decays
% Here we are assuming that the decay is of the form 
% N(t) = N0*exp(k*t), with k<0 - so the decay rate is 
% also proportional to exp(k*t).

P = polyfit(binEdges,log(decayRate),1);
figure(2)
residuals = decayRate-exp(polyval(P,binEdges));
subplot(2,2,1)
plot(binEdges,decayRate,'.',binEdges,exp(polyval(P,binEdges)),'r-');
title(sprintf('decayRate = %0.2f*exp(%0.2f*t)',exp(P(2)),P(1)));
subplot(2,2,3)
plot(binEdges,residuals,'b.')
title('Residuals')
subplot(2,2,[2 4])
normplot(residuals)

%% Fit using a sum of exponentials (assuming that we know the half-lives)

% Convert the half lives into mean lifetimes
mu = (halfLives*60)/log(2);
% Construct the design matrix of decay rate for each isotope (NB: note
% extra factor of 1/mu because we are fitting to the decay rate)
designMatrix = ...
    [exp(-binEdges/mu(1))/mu(1), exp(-binEdges/mu(2))/mu(2)];

% Use the backslash operator find the least squares solution of 
% decayRate = designMatrix*fitCoeffs, where fitCoeffs is the column vector of
% relative amounts of each isotope
fitCoeffs = designMatrix\decayRate;
% Fit values for comparison
fitValues = designMatrix*fitCoeffs;
fitResiduals = decayRate - fitValues;
figure(3)
subplot(2,2,1)
plot(binEdges,decayRate,'b.',binEdges,fitValues,'r-')
title(sprintf('Fit with isotope ratio: 1:%0.2f',(fitCoeffs(2)/fitCoeffs(1))))
subplot(2,2,3)
plot(binEdges,fitResiduals,'b.')
title('Residuals')
subplot(2,2,[2 4])
normplot(fitResiduals)

%   Copyright 2008-2009 The MathWorks, Inc. 
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $
