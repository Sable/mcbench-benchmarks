%% Demo for "Fitit"
% Copyright (c) 2011, The MathWorks, Inc.

%% Generate a set of random data

clear all
clc

s = RandStream('mt19937ar','seed',1971);
RandStream.setDefaultStream(s);

X = linspace(1,10,100);
X = X';

% Specify the parameters for a second order Fourier series

w = .6067;
a0 = 1.6345;
a1 = -.6235;
b1 = -1.3501;
a2 = -1.1622;
b2 = -.9443;

% Fourier2 is the true (unknown) relationship between X and Y
Y = a0 + a1*cos(X*w) + b1*sin(X*w) + a2*cos(2*X*w) + b2*sin(2*X*w);

% Add in a noise vector

K = max(Y) - min(Y);
noisy = Y +  .2*K*randn(100,1);

%% Generate a set of random data

s = RandStream('mt19937ar','seed',1973);
RandStream.setDefaultStream(s);

hold off

X1 = linspace(1,10,100);
X1 = X1';

% Specify the parameters for a second order Fourier series

w = rand;
a0 = randn;
a1 = randn;
b1 = randn;
a2 = randn;
b2 = randn;

% Fourier2 is the true (unknown) relationship between X and Y
Y1 = a0 + a1*cos(X*w) + b1*sin(X*w) + a2*cos(2*X*w) + b2*sin(2*X*w);

% Add in a noise vector

K = max(Y1) - min(Y1);
noisy1 = Y1 +  .2*K*randn(100,1);

foo = fitit(X1,noisy1)

% Compare the output of "fitit" with the original model

hold on
plot(X1,Y1, 'r', 'linewidth', 2)

%%  Working with the fit object

figure
plot(My_Fit)
My_Fit(noisy(1:10))

figure;
subplot(2,1,1); plot(X,My_Fit(X)); title('My Fit');
subplot(2,1,2); plot(X, differentiate(My_Fit, X)); refline(0,0),title('First derivative of My Fit');

methods(My_Fit)

%%  Add confidence intervals into the mix

[avgfit,fitstd1,fitstd2] = fitit(X,noisy,1000);

%%  Explain Localized Regression

figure
scatter(X, noisy)

fit1 = smooth(X,noisy,0.02,'loess')
hold on
plot(X, fit1, 'r', 'linewidth', 2)

fit2 = smooth(X,noisy,0.95,'loess')
plot(X, fit2, 'k', 'linewidth', 2)

fit3 = smooth(X,noisy,0.2,'loess')
plot(X, fit3, 'b', 'linewidth', 2)

%% Explain Cross Validation

% Divide data set into a test set and a training set

cp = cvpartition(size(noisy,1),'k',10);

trainingset1 = X(training(cp,1));
trainingset2 = noisy(training(cp,1));

testset1 = X(test(cp,1));
testset2 = noisy(test(cp,1));

figure
trainingscatter = scatter(trainingset1,trainingset2,'+', 'r');
hold on
testscatter = scatter(testset1, testset2,'FaceColor','b','Filled');
legend('Training Set','Test Set', 'location', 'NorthWest');

%% Use Training Set to create a LOESS smooth

delete(testscatter);
Z = smooth(trainingset1,trainingset2,.5,'loess');
ZPlot = plot(trainingset1, Z, 'color','r','linestyle','-','linewidth',2);

%% Use the test set to evaluate goodness of fit

foobar = fit(trainingset1, Z, 'cubicinterp')
scatter(testset1, testset2,'FaceColor','b','Filled')

for i = 1: length(testset1)
    
    plot([testset1(i) testset1(i)], [foobar(testset1(i)) testset2(i) ])
    
end

%%  Explain Bootstrap

figure
scatter(X, noisy, 'b')

% Create a new data set
index = randsample(length(X),length(X), 'true');
hold on
scatter(X(index), noisy(index), 'filled', 'r')
bar = fit(X(index), noisy(index), 'fourier2');
plot(bar)
legend('Original Data Set', 'Random Sample', 'Fit', 'location', 'NorthWest')


%%  Repeat

index = randsample(length(X),length(X), 'true');
scatter(X(index), noisy(index), 'filled', 'k')
bar = fit(X(index), noisy(index), 'fourier2');
plot(bar, 'k')
legend('off')

%% Repeat 20 more times

for i = 1:20
    
    index = randsample(length(X),length(X), 'true');
    bar = fit(X(index), noisy(index), 'fourier2');
    plot(bar, 'b')

end

legend off

