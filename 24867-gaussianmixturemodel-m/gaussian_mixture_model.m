function [mu_est, sigma_est, p_est, counter, difference] = ...
    gaussian_mixture_model(values, C, epsilon)
% Estimate the parameters of a 1D Gaussian Mixture model using EM.
%
% file:      	gaussian_mixture_model.m, (c) Matthew Roughan,  2009
% created: 	July 20, 2009
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
%   Inputs:
%      values  = row vector of the observed values
%                   note this only works for 1D data
%      C       = number of classes (mixtures), which should be fairly small
%      epsilon = precision for convergence
%
%   Outputs:
%      mu_est    = vectors means of each class
%      sigma_est = vector of standard deviations of each class
%      p_est     = class membership probability estimates
%      counter   = number of iterations required
%      difference= total absolute difference in parameters at each iteration to get
%                  an idea of convergence rate
%
%   A Gaussian mixture model means that each data point is drawn (randomly) from one of C
%   classes of data, with probability p_i of being drawn from class i, and each class is
%   distributed as a Gaussian with mean standard deviation mu_i and sigma_i.
%
%   For this code purpose, all distributions are 1D cause thats all I needed.
%
%   The algorithm used here for estimation is EM (Expectation Maximization). Simply put, if
%   we knew the class of each of the N input data points, we could separate them, and use
%   Maximum Likelihood to estimate the parameters of each class. This is the M step. The E
%   step makes (soft) choises of (unknown) classes for each of the data points based on the
%   previous round of parameter estimates for each class.
%
%
%   References: Estimating Gaussian Mixture Densities with EM, Carlo Tomasi, Duke University
%               http://en.wikipedia.org/wiki/Mixture_model
%

path(path, '/home/mroughan/src/matlab/NUMERICAL_ROUTINES/');

% get and check inputs
N = length(values);
if (nargin < 3)
  epsilon = 1.0e-4;
end

% initialize
counter = 0;
mu_est = 2*mean(values) * sort(rand(C,1));
sigma_est = ones(C,1)*std(values);
p_est = ones(C,1)/C;
difference = epsilon;

% now iterate
while (difference >= epsilon & counter < 25000)
  % [mu_est, sigma_est, p_est]
  
  % E step: soft classification of the values into one of the mixtures 
  for j=1:C
    class(j, :) = p_est(j) * norm_density(values, mu_est(j), sigma_est(j));
  end
  % normalize
  class = class ./ repmat(sum(class), C, 1);

  % M step: ML estimate the parameters of each class (i.e., p, mu, sigma)
  mu_est_old = mu_est;
  sigma_est_old = sigma_est;
  p_est_old = p_est;
  for j=1:C
    mu_est(j) = sum( class(j,:).*values ) / sum(class(j,:));
    sigma_est(j) = sqrt( sum(class(j,:).*(values - mu_est(j)).^2) /  sum(class(j,:)) );
    p_est(j) = mean(class(j,:));
  end
  
  difference(counter+1) = sum(abs(mu_est_old - mu_est)) + ...
      sum(abs(sigma_est_old - sigma_est)) + ...
      sum(abs(p_est_old - p_est));
  
%   if (mod(counter, 10)==0)
%     fprintf('iteration %d, difference = %.12f\n', counter, difference(counter+1));
%   end
  
  counter = counter + 1;
end


