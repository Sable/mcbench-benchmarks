% Test out GAUSSIAN_MIXTURE_MODEL
%
% file:      	gaussian_mixture_model_test.m, (c) Matthew Roughan, Tue Jul 21 2009
% directory:   /home/mroughan/src/matlab/NUMERICAL_ROUTINES/
% created: 	Tue Jul 21 2009 
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
%
%
clear;

% set parameters for 2 classes, similar to Internet traffic data
C = 2;
w = [0.7 0.3];
mu = [1 4];
sigma = [0.9 1.9];
x = -4:0.25:14;
cdf = w(1) * normcdf(x, mu(1), sigma(1)) + ...
      w(2) * normcdf(x, mu(2), sigma(2));

% generate a set of data with 2 classes
N = 10000;
r = 1 + (rand(N,1) > w(1)); % which mixture should it come from
mu_d = mu(r);
sigma_d = sigma(r);
values = mu_d + sigma_d .* randn(1,N);

% now estimate the parametes of the distribution
[mu_est, sigma_est, w_est, counter, difference] = gaussian_mixture_model(values, C, 1.0e-3);
mu_est'
sigma_est'
w_est'

% compare empirical data to estimated distribution
p1_est = w_est(1) * norm_density(x, mu_est(1), sigma_est(1));
p2_est = w_est(2) * norm_density(x, mu_est(2), sigma_est(2));

p1 = w(1) * norm_density(x, mu(1), sigma(1));
p2 = w(2) * norm_density(x, mu(2), sigma(2));

figure(3)
hold off
plot1 = plot(x, p1+p2, 'b-', 'linewidth', 2);
hold on
plot2 = plot(x, p1_est+p2_est, 'r--', 'linewidth', 2);
plot3 = plot(x, p1, 'g-.', 'linewidth', 2);
plot(x, p2, 'g-.', 'linewidth', 2);
set(gca,'linewidth', 2, 'fontsize', 16)
legend([plot3 plot1 plot2], 'components', 'mixture model', 'estimated model', ...
       'Location', 'NorthEast');

set(gcf, 'PaperPosition', [0 0 5 3]);
print('-dpng', 'gaussian_mixture_model.png');


