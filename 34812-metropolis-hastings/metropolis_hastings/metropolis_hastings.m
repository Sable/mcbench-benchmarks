%% Metropolis-Hastings algorithm: examples 1D
%{
---------------------------------------------------------------------------
*Created by:                  Date:              Comment:
 Felipe Uribe-Castillo        August 2011        Final project algorithm  
*Mail: 
 felipeuribecastillo@gmx.com
*University:
 National university of Colombia at Manizales. Civil Engineering Dept.
---------------------------------------------------------------------------
The Metropolis-Hastings algorithm:
Obtain samples from some probability distribution and to 
integrate very involved functions by random sampling. In this case the 
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
2."The Metropolis-Hastings algorithm"
   Dan Navarro & Amy Perfors.
   COMPSCI 3016: Computational cognitive science. University of Adelaide.
   http://www.psychology.adelaide.edu.au/personalpages/staff/danielnavarro/ccs2011.html
3."An introduction to MCMC for machine learning"
   C.Andrieu, N.De Freitas, A.Doucet & M.I.Jordan.
   Machine Learning, 50, 5-43, 2003.
   http://www.cs.ubc.ca/~nando/papers/mlintro.pdf
---------------------------------------------------------------------------
%}
clear; close all; home; format long g;

%% Initial data
% Parameters
nn      = 100;       % Number of samples for examine the AC
N       = 10000;     % Number of samples (iterations)
burnin  = 1000;      % Number of runs until the chain approaches stationarity
lag     = 10;        % Thinning or lag period: storing only every lag-th point
% Storage
theta   = zeros(1,N);      % Samples drawn from the Markov chain (States)
acc     = 0;               % Accepted samples
% Distributions
example = 3;
switch example
    case 1      % Example "ñoño challenge"
        sigma = 1;   mu = 1;                                % Parameters of PDFs
        proposal_PDF = @(x,mu) normpdf(x,mu,sigma);         % Proposal PDF
        sample_from_proposal_PDF = @(mu) normrnd(mu,sigma); % Function that samples from proposal PDF
        p = @(x) (x>=2).*exppdf(x,mu);                      % Target "PDF"
        aa = 1.5;   bb = 9;                                 % Limits for the graphs
        t = 3;                                              % Start point of the chain
    case 2      % Example Navarro & Perfors
        sigma = 1;   
        proposal_PDF = @(x,mu) normpdf(x,mu,sigma);   
        sample_from_proposal_PDF = @(mu) normrnd(mu,sigma);
        p = @(x) exp(-x.^2).*(2+sin(x*5)+sin(x*2)); 
        aa = -3;   bb = 3;       
        t = 0.5;    
    case 3     % Example 3
        sigma = 1;
        proposal_PDF = @(x,mu) normpdf(x,mu,sigma);
        sample_from_proposal_PDF = @(mu) normrnd(mu,sigma);       
        p = @(x) x.*exp(-x);
        aa = eps;   bb = 9;          
        t = 1;  
    otherwise   % Example Andrieu et al. Doc
        sigma = 11;
        proposal_PDF = @(x,mu) normpdf(x,mu,sigma);
        sample_from_proposal_PDF = @(mu) normrnd(mu,sigma);
        p = @(x) 0.3*exp(-0.2*x.^2) + 0.7*exp(-0.2*(x-10).^2);
        aa = -6;   bb = 16;
        t = 5;                 
end

%% M-H routine
for i = 1:burnin    % First make the burn-in stage
    [t] = MH_routine(t, p, proposal_PDF, sample_from_proposal_PDF);
end
for i = 1:N         % Cycle to the number of samples
    for j = 1:lag   % Cycle to make the thinning
        [t a] = MH_routine(t, p, proposal_PDF, sample_from_proposal_PDF);
    end
    theta(i) = t;        % Samples accepted
    acc      = acc + a;  % Accepted ?
end
accrate = acc/N;     % Acceptance rate

% Autocorrelation (AC)
pp = theta(1:nn);   pp2 = theta(end-nn:end);   % First ans Last nn samples
[r lags]   = xcorr(pp-mean(pp), 'coeff');
[r2 lags2] = xcorr(pp2-mean(pp2), 'coeff');

%% Test for convergence
% Geweke test 1992, see Ref 1. Pag. 15.
% This test split sample into two parts (after removing a burn-in period):
% The first 10% and the last 50%. If the chain is at stationarity, the means
% of two samples should be equal. i.e. if mean1~=mean2 OK!
split1 = theta(1:round(0.1*N));     split2 = theta(round(0.5*N):end);
mean1  = mean(split1);              mean2  = mean(split2) ;  
if abs((mean1-mean2)/mean1) < 0.03   % 3% error
   fprintf('\n The Geweke test OK!!! \n')
else
   fprintf('\n The Geweke test FAILS!!! \n')
end

%% Plots
% Autocorrelation
figure;
subplot(2,1,1);   stem(lags, r);
title('Autocorrelation', 'FontSize', 14);
ylabel('AC (first 100 samples)', 'FontSize', 12);
subplot(2,1,2);   stem(lags2, r2);
ylabel('AC (last 100 samples)', 'FontSize', 12);

% Histogram, target function and samples 
xx = aa:0.01:bb;   % x-axis (Graphs)
figure;
% Histogram and target dist
subplot(2,1,1);    
[n1 x1] = hist(theta, ceil(sqrt(N))); 
bar(x1, n1/(N*(x1(2)-x1(1))));   colormap summer;   hold on;  % Normalized histogram
plot(xx, p(xx)/trapz(xx,p(xx)), 'r-', 'LineWidth', 2);        % Normalized "PDF"
xlim([aa bb]); grid on; 
title('Distribution of samples', 'FontSize', 15);
ylabel('Probability density function', 'FontSize', 12);
text(aa+3,0.8,sprintf('Acceptace rate = %g', accrate),'FontSize',12);
% Samples
subplot(2,1,2);    
plot(theta, 1:N, 'b-');   xlim([aa bb]);  ylim([0 N]); grid on; 
xlabel('Location', 'FontSize', 12);
ylabel('Iterations, N', 'FontSize', 12); 

%%End