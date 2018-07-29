% This script illustrates the discrete Newton recursion	to process views on CVaR according to Entropy Pooling
% This script complements the article
%	"Fully Flexible Extreme Views"
%	by A. Meucci, D. Ardia, S. Keel
%	available at www.ssrn.com
% The most recent version of this code is available at
% MATLAB Central - File Exchange

clear; clc; close all;
rndStream = RandStream.create('mrg32k3a', 'Seed', 12, 'NumStreams', 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prior market model (normal) on grid
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
market = [];
market.mu    = 0.0;
market.sig2  = 1.0;
market.pdf   = @(x) normpdf(x, market.mu, sqrt(market.sig2));
market.cdf   = @(x) normcdf(x, market.mu, sqrt(market.sig2));
market.inv   = @(x) norminv(x, market.mu, sqrt(market.sig2));
market.VaR95 = market.inv(0.05);
market.CVaR95 = quadgk(@(x) (x .* market.pdf(x)), -100, market.VaR95) / 0.05;

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
% Entropy posterior from extreme view on CVaR: brute-force approach
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% view of the analyst
view = [];
view.CVaR95 = -3.0;

% Iterate over different VaR95 levels
nVaR95 = 100;
VaR95  = linspace(view.CVaR95, market.VaR95, nVaR95)';
p_     = NaN(J, nVaR95);
s_     = NaN(nVaR95, 1);
KLdiv  = NaN(nVaR95, 1);

for i = 1:nVaR95
   idx = (X <= VaR95(i));
   s_(i) = sum(idx);
   [p_(:, i), KLdiv(i)] = ...
       optimizeEntropy(p, idx',  0.05, [ones(1, J); (idx .* X)'], [1; 0.05 * view.CVaR95]);
end

%%%%%%%%%%%%%%%%%%%%%%%
% Display results
figure;

subplot(2, 1, 1);
plot(s_, KLdiv, '-', 'LineWidth', 1.5);
[dummy, idxMin] = min(KLdiv);
hold on; 
plot(s_(idxMin), KLdiv(idxMin), 'ko', 'MarkerFace', 'k', 'MarkerSize', 8);
grid on;
xlabel('s');
ylabel('KL divergence');

subplot(2, 1, 2);
tmp = p_(:, idxMin);
tmp = tmp / sum(tmp);
plot(X, tmp, 'color', 'r','LineWidth', 1.5);
hold on;
x = linspace(min(X), max(X), J);
tmp = market.pdf(x);
tmp = tmp / sum(tmp);
plot(x, tmp, 'color','b', 'LineWidth', 1.5);
h = legend('Posterior','Prior');
set(h, 'FontSize', 8);
hold on;
plot(market.CVaR95, 0, '^', 'Color', 'b', 'MarkerSize', 8, 'MarkerFaceColor', 'b'); 
hold on;
plot(view.CVaR95, 0, '^', 'Color', 'r', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); 
grid on;
set(gca, 'YTickLabel', '');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Entropy posterior from extreme view on CVaR: Newton Raphson approach
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s = [];

% initial value
idx = cumsum(p) <= 0.05 ;
s(1) = sum(idx);
[p_, KLdiv] = optimizeEntropy(p, idx', 0.05, [ones(1, J); (idx .* X)'], [1.0; 0.05 * view.CVaR95]);

% iterate
doStop = 0;
i = 1;
while ~doStop
   i = i + 1;
   
   idx = [ones(1, s(i-1)), zeros(1, J - s(i-1))]';
   [dummy, KLdiv_s]  = optimizeEntropy(p, idx', 0.05, [ones(1, J); (idx .* X)'], [1.0; 0.05 * view.CVaR95]);
   
   idx = [ones(1, s(i-1) + 1), zeros(1, J - s(i-1) - 1)]';
   [dummy, KLdiv_s1]  = optimizeEntropy(p, idx', 0.05, [ones(1, J); (idx .* X)'], [1.0; 0.05 * view.CVaR95]);
   
   idx = [ones(1, s(i-1) + 2), zeros(1, J - s(i-1) - 2)]';
   [dummy, KLdiv_s2]  = optimizeEntropy(p, idx', 0.05, [ones(1, J); (idx .* X)'], [1.0; 0.05 * view.CVaR95]);
   
   % first difference
   DE  = KLdiv_s1 - KLdiv_s;
   % second difference
   D2E = KLdiv_s2 - 2 * KLdiv_s1 + KLdiv_s; 
   % optimal s
   s = [s; round( s(i-1) - (DE / D2E) )]; %#ok<*AGROW>

   tmp = [];
   idx  = [ones(1, s(i)), zeros(1, J - s(i))]';
   [tmp.p_, tmp.KLdiv]  = optimizeEntropy(p, idx', 0.05, [ones(1, J); (idx .* X)'], [1.0; 0.05 * view.CVaR95]);
   p_ = [p_, tmp.p_];
   KLdiv = [KLdiv; tmp.KLdiv];
   
   % if change in KLdiv less than one percent, stop
   if abs((KLdiv(i) - KLdiv(i-1)) / KLdiv(i-1)) < 0.01 
      doStop = 1;
   end
end

%%%%%%%%%%%%%%%%%%%%%%
% Display results

N = length(s);
figure;
subplot(2, 1, 1);
plot(1:N, KLdiv, '-', 'LineWidth', 1.5);
hold on;
plot(repmat(1:N, N, 1), repmat(KLdiv', N, 1), 'o');
set(gca, 'XTick', 1:N);
grid on;
xlabel('Iterations');
ylabel('KL divergence');

subplot(2, 1, 2);
x = linspace(min(X), max(X), J);
tmp = market.pdf(x);
tmp = tmp / sum(tmp);
plot(X, tmp, 'Color', 'Blue', 'LineWidth', 1.5);
hold on; plot(X, p_(:, end), 'Color', 'Red', 'LineWidth', 1.5);
hold on; plot(market.CVaR95, 0.0, '^', 'Color', 'b', 'MarkerSize', 8, 'MarkerFaceColor', 'b'); 
hold on; plot(view.CVaR95, 0.0, '^', 'Color', 'r', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); 
grid on;
h = legend('Prior', 'Posterior', 'Location', 'NorthEast');
set(h, 'FontSize', 8);
set(gca, 'YTickLabel', '');

% zoom here
figure;
plot(X, tmp, '-b', 'LineWidth', 1.5);
hold on; plot(X, p_(:, 1), 'Color', 'Magenta', 'LineWidth', 1.5);
hold on; plot(X, p_(:, 2), 'Color', 'Green', 'LineWidth', 1.5);
hold on; plot(X, p_(:, end), 'Color', 'Red', 'LineWidth', 1.5);
hold on; plot(market.CVaR95, 0, '^', 'Color', 'b', 'MarkerSize', 8, 'MarkerFaceColor', 'b'); 
hold on; plot(view.CVaR95, 0, '^', 'Color', 'r', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); 
grid on;
xlim([-4, -2]);
set(gca, 'YTickLabel', '');
