%%  Generate a set of data points from a plane
%Copyright (c) 2011, The MathWorks, Inc.

clear all
clc

[CleanX, CleanY] = meshgrid(1:10);
CleanX = reshape(CleanX,100,1);
CleanY = reshape(CleanY,100,1);
CleanZ = 3*CleanX + 4*CleanY;

scatter3(CleanX, CleanY, CleanZ, 'filled')
hold on
foo = fit([CleanX, CleanY], CleanZ, 'poly11')
plot(foo)


%% Add noise vectors to all three dimensions

% Note:  Normally, if we were going to show a regression example, we'd
% create Noisy_Z by adding a noise vector to CleanZ but leave CleanX and
% Clean Y as is.  Here, we're using a fitting technique that is designed to
% create a model where there is noise associated with both the dependent
% and the independent variables.

NoisyX = CleanX + randn(100,1);
NoisyY = CleanY + randn(100,1);
NoisyZ = CleanZ + randn(100,1);

% create a scatter plot

figure1 = figure;
scatter3(NoisyX,NoisyY,NoisyZ, '.k')

%%  Fit a plane to the data using OLS
[foo2, GoF] = fit([NoisyX NoisyY],NoisyZ, 'poly11');

% superimpose the plane on the scatter plot
hold on
h1 = plot(foo2)
set( h1, 'FaceColor', 'r' )

%% Calculate the sum of the Squared Errors 

% Calculate the difference between the observed (NoisyX and NoisyY) and 
% the "known" value for CleanZ

resid1 = CleanZ - foo(NoisyX, NoisyY);

% Square residuals
resid1_sqrd = resid1.^2;

% Take the sum of the squared residuals
SSE_OLS = sum(resid1_sqrd)

% Create textbox
annotation(figure1,'textbox',...
    [0.147443514644351 0.802739726027397 0.305903765690377 0.0931506849315069],...
    'String',{['SSE OLS = ' num2str(SSE_OLS)]},...
    'FitBoxToText','off',...
    'BackgroundColor',[1 1 1]);

%% Use Principal Component Analysis to perform an Orthogonal Regression

% PCA is based on centering and rotation.
% PCA rotates the data such that dimension with the greatest amount of
% variance is parallel to the X axis.  The dimension with the second
% largest amount of variance will be parallel to the Y axis.  This operation
% defines a plane.  The direction with the third largest variance will be
% parallel to the Z axis.  This dimension defines a set of residuals which
% are at right angles to the XY plane.

[coeff,score,roots] = princomp([NoisyX NoisyY NoisyZ]);

basis = coeff(:,1:2);
normal = coeff(:,3);
pctExplained = roots' ./ sum(roots)

% Translate the output from PCA back to the original coordinate system

[n,p] = size([NoisyX NoisyY NoisyZ]);
meanNoisy = mean([NoisyX NoisyY NoisyZ],1);
Predicted = repmat(meanNoisy,n,1) + score(:,1:2)*coeff(:,1:2)';

% Generate a fit object that represents the output from the Orthogonal Regression
 
[foo3, Gof2] = fit([Predicted(:,1) Predicted(:,2)], Predicted(:,3), 'poly11')

h2  = plot(foo3)
set( h2, 'FaceColor', 'b' )

%% Calculate the Sum of the Squared Errors for the Orthogonal Regression
% Calculate residuals
resid2 = CleanZ - Predicted(:,3);

% Square residuals
resid2_sqrd = resid2.^2;

% Take the sum of the squared residuals
SSE_TLS = sum(resid2_sqrd)

annotation(figure1,'textbox',...
    [0.147443514644351 0.802739726027397 0.305903765690377 0.0931506849315069],...
    'String',{['SSE OLS = ' num2str(SSE_OLS)], ['SSE TLS = ' num2str(SSE_TLS)]},...
    'FitBoxToText','off',...
    'BackgroundColor',[1 1 1]);

















