%--------------------------------------------------------------------------
% Name:            GaussianPCA.m
%
% Description:     Generates samples of a multivariate Gaussian (MVG)
%                  distribution and applies PCA to extract the directions
%                  of maximum variance and project the samples onto a lower
%                  dimensional space.
%
% Author:          Brian Moore
%                  brimoor@umich.edu
%
% Date:            July 20, 2012
%--------------------------------------------------------------------------

N = 1000; % number of multivariate Gaussian (MVG) samples
DIM = 3; % MVG dimension

%--------------------------------------------------------------------------
% Generate MVG samples
%--------------------------------------------------------------------------
mu = 10;
sigma = 4;

mu = mu * rand(DIM,1);
stdev = (2 * randi([0 1],DIM) - 1) .* rand(DIM);
sigma = sigma * (stdev * stdev');
z = myMultiGaussian(mu,sigma,N); % (1/N * z * z') --> sigma as (N --> inf)
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Perform PCA
%--------------------------------------------------------------------------
PCs = 2; % must be 2 (so we can visualize results)
[y eigVecs] = myPCA(z,PCs,'eig');
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Plot z and scaled PC eigenvectors
%--------------------------------------------------------------------------
if (DIM == 2)
    figure
    plot(z(1,:),z(2,:),'g+');
    hold on
    for i = 1:PCs
        plot([mu(1) , mu(1) + eigVecs(1,i)],[mu(2) , mu(2) + eigVecs(2,i)],'b');
    end
    grid on
    title('PCA of a Bivariate Gaussian Distribution')
    set(gca,'DataAspectRatio',[1 1 1])
elseif (DIM == 3)
    figure
    plot3(z(1,:),z(2,:),z(3,:),'g+');
    hold on
    
    for i = 1:PCs
        plot3([mu(1) , mu(1) + eigVecs(1,i)],[mu(2) , mu(2) + eigVecs(2,i)],[mu(3) , mu(3) + eigVecs(3,i)],'b','Linewidth',3);
    end
    
    grid on
    title('Principal Components of the Trivariate Gaussian Samples')
    %title('Trivariate Gaussian Samples')
    set(gca,'DataAspectRatio',[1 1 1])
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Plot data in PC basis (Always a 2-D i.i.d. standard normal RV)
%--------------------------------------------------------------------------
figure
plot(y(1,:),y(2,:),'r+');
title('z in the PC(2) basis')
xlabel('PC 1 Axis')
ylabel('PC 2 Axis')
grid on
set(gca,'DataAspectRatio',[1 1 1])
%--------------------------------------------------------------------------
