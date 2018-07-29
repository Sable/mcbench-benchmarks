%--------------------------------------------------------------------------
% Name:            PCA_Demo.m
%
% Description:     Demonstrates the dimensionality reduction capabilities
%                  of PCA by projecting multivariate Gaussian samples onto
%                  a lower dimensional space and then comparing the
%                  resulting PCA reconstruction with the original samples.
%
%                  When DIM == PCs, the PCA reconstruction is *exact*. Thus
%                  PCA effectively projects the input data onto its
%                  mutually orthogonal (i.e., uncorrelated) directions of
%                  highest variance while preserving information.
%
% Author:          Brian Moore
%                  brimoor@umich.edu
%
% Date:            July 20, 2012
%--------------------------------------------------------------------------

N = 100; % number of multivariate Gaussian (MVG) samples
DIM = 3; % MVG dimension
PCs = 2; % number of principal components (PC) to extract

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
[z_pc T U mean_z] = myPCA(z,PCs);
z_LD = U / T * z_pc + repmat(mean_z,1,size(z,2)); % Low-dimensional approximation of z
z_pc_cov = cov(z_pc') %#ok
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
for i = 1:PCs
    subplot(PCs,1,i)
    plot(z_pc(i,:),'b')
    grid on
    ylabel(['z_{pc}_' num2str(i)])
end
subplot(PCs,1,1)
title([num2str(PCs) ' Prinicpal Components of z (Centered and Normalized)'])

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
title([num2str(PCs) '-Dimensional PCA Approximation of ' num2str(DIM) '-Dimensional Data z'])
legend([r,b],'Actual z',[num2str(PCs) '-D PCA Approximation of z'])
%--------------------------------------------------------------------------
