%% Metropolis-Hastings algorithm: example 2D
%{
---------------------------------------------------------------------------
*Created by:                  Date:              Comment:
 Felipe Uribe-Castillo        August 2011        Final project algorithm  
*Mail: 
 felipeuribecastillo@gmx.com
*University:
 National university of Colombia at Manizales. Civil engineering Dept.
---------------------------------------------------------------------------
The Metropolis-Hastings algorithm:
Obtain samples from some complex probability distribution in order to 
integrate very complex functions by random sampling. In this case the 
candidate distribution its no longer symmetric. 
The M-H algorithm can draw samples from any probability distribution P(x), 
requiring only that a function proportional to the density can be calculated. 
In Bayesian applications, the normalization factor is often extremely 
difficult to compute, so the ability to generate a sample without knowing 
this constant of proportionality is a major virtue of the algorithm.

This program needs the "MH_routine" function.

Original contribution: 
-"Equations of State Calculations by Fast Computing Machines"
  Metropolis, Rosenbluth, Rosenbluth, Teller & Teller (1953).
-"Monte Carlo Sampling Methods Using Markov Chains and Their Applications"
  W.K.Hastings (1970).
---------------------------------------------------------------------------
Based on:
1."Markov chain Monte Carlo and Gibbs sampling"
   B.Walsh.
   Lecture notes for EEB 581, version april 2004.
   http://web.mit.edu/~wingated/www/introductions/mcmc-gibbs-intro.pdf
2."An introduction to MCMC for machine learning"
   C.Andrieu, N.De Freitas, A.Doucet & M.I.Jordan.
   Machine Learning, 50, 5-43, 2003.
   http://www.cs.ubc.ca/~nando/papers/mlintro.pdf
---------------------------------------------------------------------------
%}
clear; close all; home; format short g;

%% Initial data
% Parameters
N      = 30000;    % Number of samples (iterations)
burnin = 3000;     % Number of runs until the chain approaches stationarity   
lag    = 10;       % Thinning or lag period: storing only every lagth point
acc    = 0;        % To note the acceptance
% Storage and initial points
theta = zeros(2,N);   % Samples drawn from the Markov chain
tt    = [3 1.5];      % Start points or initial states of the chain in X and Y

%% Target "PDF"
% First bivariate normal parameters
muX = 1;   varX = 1;  corrXY = 0.6;
muY = 1;   varY = 4;  covXY = sqrt(varX)*sqrt(varY)*corrXY; 
mu_dist1 = [muX muY]; cov_dist1 = [varX covXY; covXY varY];     % Means and Covariance Matrix for target "PDF"
% Second bivariate normal parameters
muX = 3;     varX = 0.49;  corrXY = -0.5;
muY = 1.5;   varY = 0.09;  covXY = sqrt(varX)*sqrt(varY)*corrXY; 
mu_dist2 = [muX muY]; cov_dist2 = [varX covXY; covXY varY];     % Means and Covariance Matrix for target "PDF"
% Target "PDF"
p = @(X) mvnpdf(X,mu_dist1,cov_dist1) + mvnpdf(X,mu_dist2,cov_dist2);  % Gaussian mixture

%% Proposal PDF
% Bivariate normal parameters
varX_proposal  = 1;    varY_proposal = 1;   corrXY_proposal = -0.5;         % Var(X), var(Y) and CorCoef(X,Y) for proposal, assumed
covXY_proposal = sqrt(varX_proposal)*sqrt(varY_proposal)*corrXY_proposal;   % Cov(XY)for proposal
cov_proposal_PDF = [varX_proposal   covXY_proposal;...
                    covXY_proposal  varY_proposal];    % Covariance Matrix for proposal
% Proposal PDF                 
proposal_PDF = @(X,mu) mvnpdf(X,mu,cov_proposal_PDF);          % Proposal PDF
sample_from_proposal_PDF = @(mu) mvnrnd(mu,cov_proposal_PDF);  % Function that samples from proposal PDF

%% Marginals
X = (-6:0.05:6)';   nx = length(X);
Y = (-6:0.05:6)';   ny = length(Y);
[XX,YY] = meshgrid(X,Y);
pXY = @(x,y) mvnpdf([x' y'],mu_dist1,cov_dist1) + mvnpdf([x' y'],mu_dist2,cov_dist2); 
pX = zeros(nx,1);
for i = 1:nx
   pX(i) = quad(@(y) pXY(repmat(X(i),1,length(y)),y), -10, 10);  % Marginal X
end
pY = zeros(ny,1);
for i = 1:ny
   pY(i) = quad(@(x) pXY(x,repmat(Y(i),1,length(x))), -10, 10);  % Marginal Y
end

%% M-H routine
for i = 1:burnin   % First make the burn-in stage
   [tt a] = MH_routine(tt,p,proposal_PDF,sample_from_proposal_PDF); 
end
for i = 1:N   % Cycle to the number of samples
   for j = 1:lag   % Cycle to make the thinning
      [tt a] = MH_routine(tt,p,proposal_PDF,sample_from_proposal_PDF);
   end
   theta(:,i) = tt;        % Store the chosen states
   acc        = acc + a;   % Accepted ?
end
accrate = acc/N;           % Acceptance rate

%% Autocorrelation
nn = 100;          % Number of samples for examine the AC
pp = theta(1,1:nn);   pp2 = theta(1,end-nn:end);   % First ans Last nn samples in X
qq = theta(2,1:nn);   qq2 = theta(2,end-nn:end);   % First and Last nn samples in Y
% AC in X
[r lags]   = xcorr(pp-mean(pp), 'coeff');
[r2 lags2] = xcorr(pp2-mean(pp2), 'coeff');
% AC in Y
[r3 lags3] = xcorr(qq-mean(qq), 'coeff');
[r4 lags4] = xcorr(qq2-mean(qq2), 'coeff');

%% Plots
% Autocorrelation
figure;
subplot(2,2,1);   stem(lags, r);
title('Autocorrelation in X', 'FontSize', 14);
ylabel('AC (first 100 samples)', 'FontSize', 12);
subplot(2,2,3);   stem(lags2, r2);
ylabel('AC (last 100 samples)', 'FontSize', 12);
subplot(2,2,2);   stem(lags3, r3);
title('Autocorrelation in Y', 'FontSize', 14);
ylabel('AC (first 100 samples)', 'FontSize', 12);
subplot(2,2,4);   stem(lags4, r4);
ylabel('AC (last 100 samples)', 'FontSize', 12);

% Target function and samples 
Z = p([XX(:) YY(:)]);  Z = reshape(Z,length(YY),length(XX));
figure;
subplot(2,1,1);   % Target "PDF"
surf(X,Y,Z); grid on; shading interp;
xlabel('X', 'FontSize', 12);  ylabel('Y', 'FontSize', 12);  
title('f_{XY}(x,y)', 'FontSize', 12);
subplot(2,1,2);   % Distribution of samples
plot(theta(1,:),theta(2,:),'k.','LineWidth',1); hold on; 
contour(X,Y,Z,22,'--','LineWidth',2); colormap jet; axis tight;
xlabel('X', 'FontSize', 12);   ylabel('Y', 'FontSize', 12);
text(3,-3,sprintf('Acceptace rate = %g', accrate),'FontSize',11);

% Joint, Marginals and histograms
figure;
% Marginal Y
subplot(4,4,[1 5 9]);
[n2 x2] = hist(theta(2,:), ceil(sqrt(N))); 
barh(x2, n2/(N*(x2(2)-x2(1))));   hold on;               % Normalized histogram
set(gca,'XDir','reverse','YAxisLocation','right', 'Box','off'); 
xlabel('pY(y)', 'FontSize', 15) 
plot(pY/trapz(Y,pY),Y,'r-','LineWidth',2); axis tight;   % Normalized marginal
% Marginal X
subplot(4,4,[14 15 16]);
[n1 x1] = hist(theta(1,:), ceil(sqrt(N))); 
bar(x1, n1/(N*(x1(2)-x1(1))));   axis tight;   hold on;  % Normalized histogram
set(gca,'YDir','reverse','XAxisLocation','top','Box','off'); 
ylabel('pX(x)', 'FontSize', 15)
plot(X,pX/trapz(X,pX),'r-','LineWidth',2);               % Normalized marginal
% Distribution of samples
subplot(4,4,[2 3 4 6 7 8 10 11 12]);  
plot(theta(1,:),theta(2,:),'b.','LineWidth',1); axis tight; hold on; 
contour(X,Y,Z,22,'--','LineWidth',2); colormap summer; 
title('Distribution of samples', 'FontSize', 15);
xlabel('X', 'FontSize', 15);   ylabel('Y', 'FontSize', 15);

% Useful Matlab command
figure;
scatterhist(theta(1,:),theta(2,:),[ceil(sqrt(N)) ceil(sqrt(N))]); hold on; 
contour(X,Y,Z,22,'--','LineWidth',2); colormap summer;

%%End