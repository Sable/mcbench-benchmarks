%--------------------------------------------------------------------------
% Name:            ICA_Demo.m
%
% Description:     Demonstrates the performance of ICA by decomposing
%                  correlated multivariate Gaussian samples into
%                  uncorrelated and maximally independent (in the
%                  negentropy sense) data streams.
%
%                  When DIM == ICs, the ICA reconstruction is *exact*. Thus
%                  ICA effectively transforms the input data into
%                  uncorrelated, independent components while preserving
%                  information.
%
% Author:          Brian Moore
%                  brimoor@umich.edu
%
% Date:            July 20, 2012
%--------------------------------------------------------------------------

N = 100; % number of multivariate Gaussian (MVG) samples
DIM = 3; % MVG dimension
ICs = 3; % number of independent components (PC) to decompose into

%--------------------------------------------------------------------------
% Generate MVG samples
%--------------------------------------------------------------------------
muScale = 10;
sigmaScale = 3;

mu = muScale * rand(DIM,1);
stdev = (2 * randi([0 1],DIM) - 1) .* rand(DIM);
sigma = sigmaScale * (stdev * stdev');
z = myMultiGaussian(mu,sigma,N);
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Perform PCA
%--------------------------------------------------------------------------
[z_ic A T mean_z] = myICA(z,ICs);
z_LD = T \ pinv(A) * z_ic + repmat(mean_z,1,size(z,2)); % Low-dimensional approximation of z
z_ic_cov = cov(z_ic') %#ok
%--------------------------------------------------------------------------

%{
%--------------------------------------------------------------------------
% Compute variance/residual data
%--------------------------------------------------------------------------
vars = diag(cov(z')); % Variance of each element of z
resids = zeros(DIM,1);
for i = 1:DIM
    resids(i) = norm(z(i,:) - z_LD(i,:));
end
%--------------------------------------------------------------------------
%}

%--------------------------------------------------------------------------
% Plot results
%--------------------------------------------------------------------------
figure
for i = 1:ICs
    subplot(ICs,1,i)
    plot(z_ic(i,:),'b')
    grid on
    ylabel(['z_{ic}_' num2str(i)])
end
subplot(ICs,1,1)
title([num2str(ICs) ' Independent Components of z (Centered and Normalized)'])

figure
for i = 1:DIM
    subplot(DIM,1,i)
    r = plot(z(i,:),'--r');
    hold on
    b = plot(z_LD(i,:),'-.b');
    grid on
    %xlabel(['Var(' num2str(i) ') = ' num2str(vars(i)) ' - Resid(' num2str(i) ') = ' num2str(resids(i))])
    ylabel(['z_' num2str(i)])
end
subplot(DIM,1,1)
title([num2str(ICs) '-Dimensional ICA Decomposition of ' num2str(DIM) '-Dimensional Data z'])
legend([r,b],'Actual z',[num2str(ICs) '-D ICA Approximation of z'])
%--------------------------------------------------------------------------
