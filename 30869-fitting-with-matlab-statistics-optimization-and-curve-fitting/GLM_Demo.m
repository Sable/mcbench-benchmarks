%%  Generalized Linear Model Demo
%Copyright (c) 2011, The MathWorks, Inc.

% Generalized Linear Models ecompasses techniques like Poisson 
% regression and Logistic rgeression. This technique is used to model
% counts and estimate odds.

% Formally, the technique was developed to model data where the error terms
% don't exhibit constant variance.

% Specify the average relationship between X and Y

clear all
clc

% Create a set of 100 X values between 0 and 15

X = linspace(0,15,100);
X = X';

% Define a function that describes the average relationship between X and
% Y.  

mu = @(x) exp(-1.5 +.25*x);
Y = mu(X);

plot(X,Y); 
xlabel('Time');
ylabel('Count');

%%  Use the Y = f(X) to generate a dataset with known characteristics

%  At each "X", the observed Y is represented as a draw from a Poisson
%  distribution with mean (lambda) = Y

Noisy_Y = poissrnd(Y,100,1);

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'YTick',[0:max(Noisy_Y)], 'YGrid','on');
hold(axes1,'all');

% Create scatter
scatter(X,Noisy_Y, 'b');

xlabel('Time')
ylabel('Count')

% Note the following:

% The mean of a poisson process is also the variance of a poisson process.
% The blue curve doesn't exhibit constant variance (this violates one of
% the key assumptions underlying Ordinary Least Squares)

% The output from a Poisson process is always a non-negative integer.  If
% lambda is close to zero AND observations can never going
% non-negative, the shape of the distribution is bounded in one direction.
% As lambda gets larger, this boundary has less and less impact on the
% distribution of the errors.

hold on
plot(X,Y); 

%%  Create a fit using nonlinear regression

% The model used for the nonlinear regression is the same as "mu"

foo = fit(X, Noisy_Y, 'exp(B1 + B2*x)');
plot(foo)

xlabel('Time')
ylabel('Count')

SSE_OLS = sum((foo(X) - Noisy_Y).^2)

% Create textbox
annotation(figure1,'textbox',...
    [0.147443514644351 0.802739726027397 0.255903765690377 0.0931506849315069],...
    'String',{['SSE OLS = ' num2str(SSE_OLS)]},...
    'FitBoxToText','off',...
    'BackgroundColor',[1 1 1]);


%% Create a fit using a Generalized Linear Model

[b dev stats] = glmfit(X,Noisy_Y, 'poisson');

Predicted_Y = exp(b(1) + b(2)*X);
plot(X, Predicted_Y, 'k');

SSE_GLM = sum(stats.resid.^2)

% Create textbox
annotation(figure1,'textbox',...
    [0.147443514644351 0.802739726027397 0.255903765690377 0.0931506849315069],...
    'String',{['SSE OLS = ' num2str(SSE_OLS)], ['SSE GLM = ' num2str(SSE_GLM)]},...
    'FitBoxToText','off',...
    'BackgroundColor',[1 1 1]);

%  The two curves (should) look almost the same
%  The SSE is (essentially) the same.
% What gives?  Why are we bothering with this GLM stuff?

%% Perform a Monte Carlo simulation

% Generate 1000 data sets that are consistent with with the assumed
% relationship between Count and Time

parfor i = 1:1000

     Noisy_Y = poissrnd(Y, 100,1);

     b = glmfit(X,Noisy_Y, 'poisson');

     GLM_Prediction(:,i) = exp(b(1) + b(2)*X); 
     
     % Provide optimal starting conditions (make sure that ...
     % any differences are related to the algorithms rather than
     % convergence
     
     foo = fit(X, Noisy_Y, 'exp(B1 + B2*x)', 'Startpoint', [-1.5, .25]);
     
     B = coeffvalues(foo);
     
     OLS_Prediction(:,i) = exp(B(1) + B(2)*X);
     
end

figure

True = plot(X, Y, 'b');
hold on
GLM_Mean = plot(X, mean(GLM_Prediction, 2),'k')
OLS_Mean = plot(X, mean(OLS_Prediction, 2),'r')
xlabel('Time')
ylabel('Count')

% The means of the two two techniques are, for all intents and purposes,
% identical.

%%

% The standard deviation from the GLM is MUCH smaller.  Also note that 
% I provided the nonlinear regression with optimal starting conditions.

% Formally, the advantage to using a GLM has to do with the scope of the
% technique (The range of conditions over which the GLM will generate a
% good fit).  GLMs have a much broader scope.  Conversely, using a
% nonlinear regression to fit the inverse of the link function can (badly)
% misfire on occasion.

% glmfit is more robust

GLM_std = std(GLM_Prediction, [], 2);
OLS_std = std(OLS_Prediction, [], 2);

figure
plot(X, OLS_std./GLM_std)
xlabel('Time')
ylabel('Ratio of OLS std:GLM std')






