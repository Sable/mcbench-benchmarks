%% Simple Metropolis algorithm example
%{
---------------------------------------------------------------------------
*Created by:                  Date:            Comment:
 Felipe Uribe-Castillo        July 2011        Final project algorithm  
*Mail: 
 felipeuribecastillo@gmx.com
*University:
 National university of Colombia at Manizales. Civil Engineering Dept.
---------------------------------------------------------------------------
The Metropolis algorithm:
First MCMC to obtain samples from some complex probability distribution
and to integrate very complex functions by random sampling. 
It considers only symmetric proposals (proposal pdf). 

Original contribution: 
-"The Monte Carlo method"
  Metropolis & Ulam (1949).
-"Equations of State Calculations by Fast Computing Machines"
  Metropolis, Rosenbluth, Rosenbluth, Teller & Teller (1953).
---------------------------------------------------------------------------
Based on:
1."Markov chain Monte Carlo and Gibbs sampling"
   B.Walsh ----- Lecture notes for EEB 581, version april 2004.
   http://web.mit.edu/~wingated/www/introductions/mcmc-gibbs-intro.pdf
%}
clear; close all; home; format long g;

%% Initial data
% Distributions 
nu           = 5;                                       % Target PDF parameter
p            = @(t) (t.^(-nu/2-1)).*(exp(-1./(2*t)));   % Target "PDF", Ref. 1 - Ex. 2
proposal_PDF = @(mu) unifrnd(0,3);                      % Proposal PDF
% Parameters
N        = 1000;              % Number of samples (iterations)
nn       = 0.1*(N);           % Number of samples for examine the AutoCorr
theta    = zeros(1,N);        % Samples drawn form the target "PDF"
theta(1) = 0.3;               % Initial state of the chain

%% Procedure
for i = 1:N
   theta_ast = proposal_PDF([]);          % Sampling from the proposal PDF
   alpha     = p(theta_ast)/p(theta(i));  % Ratio of the density at theta_ast and theta points
   if rand <= min(alpha,1)
      % Accept the sample with prob = min(alpha,1)
      theta(i+1) = theta_ast;
   else
      % Reject the sample with prob = 1 - min(alpha,1)
      theta(i+1) = theta(i);
   end
end

% Autocorrelation (AC)
pp = theta(1:nn);   pp2 = theta(end-nn:end);   % First ans Last nn samples
[r lags]   = xcorr(pp-mean(pp), 'coeff');
[r2 lags2] = xcorr(pp2-mean(pp2), 'coeff');

%% Plots
% Autocorrelation
figure;
subplot(2,1,1);   stem(lags,r);
title('Autocorrelation', 'FontSize', 14);
ylabel('AC (first samples)', 'FontSize', 12);
subplot(2,1,2);   stem(lags2,r2);
ylabel('AC (last samples)', 'FontSize', 12);

% Samples and distributions
xx = eps:0.01:10;   % x-axis (Graphs)
figure;
% Histogram and target dist
subplot(2,1,1); 
[n1 x1] = hist(theta, ceil(sqrt(N)));
bar(x1,n1/(N*(x1(2)-x1(1))));   colormap summer;   hold on;   % Normalized histogram
plot(xx, p(xx)/trapz(xx,p(xx)), 'r-', 'LineWidth', 3);        % Normalized function
grid on;   xlim([0 max(theta)]);   
title('Distribution of samples', 'FontSize', 14);
ylabel('Probability density function', 'FontSize', 12);
% Samples
subplot(2,1,2);     
plot(theta, 1:N+1, 'b-');   xlim([0 max(theta)]);   ylim([0 N]);   grid on;
xlabel('Location', 'FontSize', 12);
ylabel('Iterations, N', 'FontSize', 12); 

%%End