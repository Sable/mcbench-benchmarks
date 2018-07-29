function [E, E1, E2, Et, Et1, Et2] = testClassSeperability(N,MEAN1,STD1,MEAN2,STD2, PLOT)

%
% This function generates two random Gaussian sequences and computes 
% both the theoretical error and the histogram-based method, using
% respectively the functions computeHistError() and theoreticalError().
%
%
% ARGUMENTS:
% N: number of samples per class
% MEAN1: average value of the samples (1st class)
% STD1: standard deviation of the samples (1st class)
% MEAN2: average value of the samples (2nd class)
% STD2: standard deviation of the samples (2nd class)
% PLOT: this is 1 if results are to be plotted
%
% --------------------------------------------
% Theodoros Giannakopoulos
% Dep. of Informatics and Telecommunications
% University of Athens, Greece
% http://www.di.uoa.gr/~tyiannak
% --------------------------------------------
%


if (N<100)
    fprintf('N has to be at lest 1000!\n');
    return;
end

% GENERATE DATASETS (normal distribution)
x1 = randn(N,1) * sqrt(STD1) + MEAN1;
x2 = randn(N,1) * sqrt(STD2) + MEAN2;

if (N<1000)
    nBins = 10;
else
    if (N<10000)
        nBins = 50;
    else
        nBins = 100;
    end
end

% CALCULATE HISTOGRAMS FOR BOTH CLASSES:
step = (max(MEAN1,MEAN2) - min(MEAN1,MEAN2)) / nBins;
X = min(MEAN1-3*STD1,MEAN2-3*STD2): step : max(MEAN1+3*STD1,MEAN2+3*STD2);
[H1, X1] = hist(x1, X);
[H2, X2] = hist(x2, X);

% COMPUTE THE ERROR PROBABILITIES FOR BOTH CLASSES using the historam method:
%
% N O T E : this function computes the error classification probability for
% the training data using the histograms as a pdf estimation method.
% Therefore, it can be used for any distribution of input data.
%

[E1, E2] = computeHistError(x1, x2);
E1 = 100* E1;
E2 = 100* E2;

% OVERALL ERROR PROBABILITY:
E = (E1 + E2) / 2;

if (PLOT==1)
    figure;
    subplot(2,1,1);
    str = sprintf('Estimated Errors: E1 = %.2f%%, E2 = %.2f%%, E = %.2f%%.', E1, E2, E);        
    plot(X1, H1);
    hold on;
    plot(X2, H2,'r');
    legend('Class A','Class B');
    title(str);
    axis([min(MEAN1-3*STD1,MEAN2-3*STD2) max(MEAN1+3*STD1,MEAN2+3*STD2) 0 max([H1 H2])]);    
    subplot(2,1,2);    
    [Et, Et1, Et2, x] = theoreticalError(MEAN1, STD1, MEAN2, STD2);    
    str = sprintf('Theoretical Errors: E1 = %.2f%%, E2 = %.2f%%, E = %.2f%%.', Et1, Et2, Et);    
    title(str);
end
