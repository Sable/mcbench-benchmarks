function [y,c]=hp(z,lambda);
% PURPOSE: Hodrick-Prescott filtering
% ------------------------------------------------------------
% SYNTAX: [y,c]=hp(z,lambda);
% ------------------------------------------------------------
% OUTPUT: y: nx1 --> long-term trend
%         c: nx1 --> cycle as deviation from long-term trend (as %)
% ------------------------------------------------------------
% INPUT: z: nx1      --> short-term trend or s.a. time series
%        lambda: 1x1 --> balance between adjustment and smoothness
% ------------------------------------------------------------
% LIBRARY: dif
% ------------------------------------------------------------

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 2.0 [May 2009]

% Size of the input data
[n,m] = size(z);

% Second difference matrix
D = dif(2,n);
D(1:2,:) = [];

% Matrix form of the filter (non inverted)
H = eye(n) + lambda*(D'*D);

% Computing long-term trend
y = H \ z;

% Computing cycle as deviation from long term trend
c = 100 * (z - y) ./ y;

