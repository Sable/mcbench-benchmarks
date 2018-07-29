%% Diplay mesh points based on Gaussian-Hermite quadrature
% This script complements the article
%	"Fully Flexible Extreme Views"
%	by A. Meucci, D. Ardia, S. Keel
%	available at www.ssrn.com
% The most recent version of this code is available at
% MATLAB Central - File Exchange

clc;
clear all;
close all;

N = 50; 
X = NaN(N, N);

for i = 1:N
    x = gaussHermiteMesh(i);
    X(1:length(x), i) = x;
end

% mesh points
figure;
plot(1:N, X', 'o', 'MarkerFace', 'k', 'Color', 'k', 'MarkerSize', 3);
grid on;