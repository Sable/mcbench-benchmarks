% This script estimates the prior of a hedge fund return and processes extreme views on CVaR 
% according to Entropy Pooling
% This script complements the article
%	"Fully Flexible Extreme Views"
%	by A. Meucci, D. Ardia, S. Keel
%	available at www.ssrn.com
% The most recent version of this code is available at
% MATLAB Central - File Exchange

% IMPORTANT - This script is about the methodology, not the input data, which has been modified

clear; clc; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fetch data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load pseudodata;

xi = 100 * cell2mat(data(:, 2));
n = length(xi);

% bandwith
bw = kernelbw(xi);

% weights
lambda = log(2) / (n / 2);
wi = exp(-lambda * (n - (n:-1:1)'));
wi = flipud(wi) / sum(wi);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prior market model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kernel density
market = [];
market.mu  = mean(xi);
market.pdf = @(x) kernelpdf(x, xi, bw, wi);
market.cdf = @(x) kernelcdf(x, xi, bw, wi);
market.inv = @(x) kernelinv(x, xi, bw, wi);
market.VaR95 = market.inv(0.05);
market.CVaR95 = quadgk(@(x) (x .* market.pdf(x)), -100, market.VaR95) / 0.05;


% numerical (Gauss-Hermite grid) prior 
load ghq1000.mat % load mesh of GH zeros 
tmp = (ghqx-min(ghqx))/(max(ghqx)-min(ghqx)); % rescale GH zeros so they belong to [0,1]
epsilon = 1e-10;
Lower = market.inv(epsilon);
Upper = market.inv(1-epsilon);
X  = Lower + tmp * (Upper-Lower); % rescale mesh

p = integrateSubIntervals(X, market.cdf);
p = normalizeProb(p);
J = length(X); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Entropy posterior from extreme view on mean and CVaR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
view = [];
view.mu   = mean(xi) - 1.0; 
view.CVaR95 = market.CVaR95 - 1.0; 

% Netwton Raphson
s = []; 
idx = cumsum(p) <= 0.05 ;
s(1) = sum(idx);
[p_, KLdiv] = optimizeEntropy(p, idx', 0.05, [ones(1, J); X'; (idx .* X)'], [1; view.mu; 0.05 * view.CVaR95]);
%[p_, KLdiv] = optimizeEntropy(p, [idx'; (idx .* X)'], [0.05; 0.05 * view.CVaR95], [ones(1, J); X'], [1; view.mu]);

doStop = 0;
i = 1;
while ~doStop
   i = i + 1;

   idx = [ones(1, s(i-1)), zeros(1, J - s(i-1))]';
   [dummy, KLdiv_s]  = optimizeEntropy(p, idx', 0.05, [ones(1, J); X'; (idx .* X)'], [1; view.mu; 0.05 * view.CVaR95]);
   %[dummy, KLdiv_s]  = optimizeEntropy(p, [idx'; (idx .* X)'], [0.05; 0.05 * view.CVaR95], [ones(1, J); X'], [1; view.mu]);
   
   idx = [ones(1, s(i-1) + 1), zeros(1, J - s(i-1) - 1)]';
   [dummy, KLdiv_s1]  = optimizeEntropy(p, idx', 0.05, [ones(1, J); X'; (idx .* X)'], [1; view.mu; 0.05 * view.CVaR95]);
   %[dummy, KLdiv_s1] = optimizeEntropy(p, [idx'; (idx .* X)'], [0.05; 0.05 * view.CVaR95], [ones(1, J); X'], [1; view.mu]);
   
   idx = [ones(1, s(i-1) + 2), zeros(1, J - s(i-1) - 2)]';
   [dummy, KLdiv_s2]  = optimizeEntropy(p, idx', 0.05, [ones(1, J); X'; (idx .* X)'], [1; view.mu; 0.05 * view.CVaR95]);
   %[dummy, KLdiv_s2] = optimizeEntropy(p, [idx'; (idx .* X)'], [0.05; 0.05 * view.CVaR95], [ones(1, J); X'], [1; view.mu]);

   % first difference
   DE  = KLdiv_s1 - KLdiv_s;
   % second difference
   D2E = KLdiv_s2 - 2 * KLdiv_s1 + KLdiv_s;
   % optimal s
   s = [s; round( s(i-1) - (DE / D2E) )]; 

   tmp = [];
   idx  = [ones(1, s(i)), zeros(1, J - s(i))]';
   [tmp.p_, tmp.KLdiv]  = optimizeEntropy(p, idx', 0.05, [ones(1, J); X'; (idx .* X)'], [1; view.mu; 0.05 * view.CVaR95]);
   %[tmp.p_, tmp.KLdiv] = optimizeEntropy(p, [idx'; (idx .* X)'], [0.05; 0.05 * view.CVaR95], [ones(1, J); X'], [1; view.mu]);
   p_ = [p_, tmp.p_]; 
   KLdiv = [KLdiv; tmp.KLdiv]; %#ok<*AGROW>
   
   % if change in KLdiv less than one percent, stop
   if abs((KLdiv(i) - KLdiv(i-1)) / KLdiv(i-1)) < 0.01 
      doStop = 1;
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
plot(X, p, 'b', 'LineWidth', 1.5);
hold on;
plot(X, p_(:, end), 'r', 'LineWidth', 1.5);
hold on; plot(market.mu, 0.0, 'o', 'Color', 'Blue', 'MarkerSize', 8, 'MarkerFaceColor', 'Blue'); 
hold on; plot(market.CVaR95, 0.0, '^', 'Color', 'Blue', 'MarkerSize', 8, 'MarkerFaceColor', 'Blue'); 
hold on; plot(view.mu, 0.0, 'o', 'Color', 'Red', 'MarkerSize', 8, 'MarkerFaceColor', 'Red'); 
hold on; plot(view.CVaR95, 0.0, '^', 'Color', 'Red', 'MarkerSize', 8, 'MarkerFaceColor', 'Red'); 
grid on;
xlabel('Returns [%]');
h = legend('Prior', 'Posterior');
set(h, 'FontSize', 8);
set(gca, 'YTickLabel', '');
