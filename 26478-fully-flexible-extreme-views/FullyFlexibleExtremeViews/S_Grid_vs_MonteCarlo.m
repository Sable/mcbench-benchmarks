% This script compares the performance of plain Monte Carlo 
% versus grid in applying Entropy Pooling to process extreme views
% This script complements the article
%	"Fully Flexible Extreme Views"
%	by A. Meucci, D. Ardia, S. Keel
%	available at www.ssrn.com
% The most recent version of this code is available at
% MATLAB Central - File Exchange

clc; clear all; close all;
rndStream = RandStream.create('mrg32k3a', 'Seed', 12, 'NumStreams', 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prior market model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% analytical (normal) prior
market = [];
market.mu   = 0.0;
market.sig2 = 1.0;
market.pdf  = @(x) normpdf(x, market.mu, sqrt(market.sig2));
market.cdf  = @(x) normcdf(x, market.mu, sqrt(market.sig2));
market.rnd  = @(n) market.mu + sqrt(market.sig2) * randn(rndStream, n, 1);
market.inv  = @(x) norminv(x, market.mu, sqrt(market.sig2));

% numerical (Monte Carlo) prior 
monteCarlo = [];
monteCarlo.J = 100000;
monteCarlo.X = market.rnd(monteCarlo.J);
monteCarlo.p = normalizeProb(1/monteCarlo.J * ones(monteCarlo.J, 1));

% numerical (Gauss-Hermite grid) prior 
ghqMesh = [];
load ghq1000.mat % load mesh of GH zeros 
tmp = (ghqx-min(ghqx))/(max(ghqx)-min(ghqx)); % rescale GH zeros so they belong to [0,1]
epsilon = 1e-10;
Lower = market.inv(epsilon);
Upper = market.inv(1-epsilon);
ghqMesh.X  = Lower + tmp*(Upper-Lower); % rescale mesh

p = integrateSubIntervals(ghqMesh.X, market.cdf);
ghqMesh.p = normalizeProb(p);
ghqMesh.J = length(ghqMesh.X); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Entropy posterior from extreme view on expectation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% view of the analyst
view = [];
view.mu = -3.0; 

% analytical (known since normal model has analtical solution)
truePosterior = [];
[truePosterior.mu, truePosterior.sig2] = Prior2Posterior(market.mu, 1, view.mu, market.sig2, 0);
truePosterior.pdf = @(x) normpdf(x, truePosterior.mu, sqrt(truePosterior.sig2));

% numerical (Monte Carlo)
[monteCarlo.p_, monteCarlo.KLdiv] = ... 
    optimizeEntropy(monteCarlo.p, [], [], [ones(1, monteCarlo.J); monteCarlo.X'], [1; view.mu]);

% numerical (Gaussian-Hermite grid)
[ghqMesh.p_, ghqMesh.KLdiv] = ... 
    optimizeEntropy(ghqMesh.p, [], [], [ones(1, ghqMesh.J); ghqMesh.X'], [1; view.mu]);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xmin = min(ghqMesh.X);
xmax = max(ghqMesh.X);
ymax = 1.0;
xmesh = linspace(xmin, xmax, ghqMesh.J)'; 

figure;
pHist(monteCarlo.X, monteCarlo.p_);
hold on; plot(xmesh, market.pdf(xmesh), 'linewidth', 1.5, 'color', 'b');
hold on; plot(xmesh, truePosterior.pdf(xmesh), 'linewidth', 1.5, 'color', 'r');
hold on; plot(xmesh, truePosterior.pdf(xmesh), 'linewidth', 1.5, 'color', 'r');
hold on; plot(0, 0, '^', 'Color', 'b', 'MarkerSize', 8, 'MarkerFaceColor', 'b'); 
hold on; plot(view.mu, 0, '^', 'Color', 'r', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); 
ylim([0, ymax]);
title('Monte Carlo');

figure;
pHist(ghqMesh.X, ghqMesh.p_);
hold on; plot(xmesh, market.pdf(xmesh), 'linewidth', 1.5, 'color', 'b');
hold on; plot(xmesh, truePosterior.pdf(xmesh), 'linewidth', 1.5, 'color', 'r');
hold on; plot(0, 0, '^', 'Color', 'b', 'MarkerSize', 8, 'MarkerFaceColor', 'b'); 
hold on; plot(view.mu, 0, '^', 'Color', 'r', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); 
ylim([0, ymax]);
title('Gauss-Hermite grid');
