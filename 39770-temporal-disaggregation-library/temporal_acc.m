function [za] = temporal_acc(z,op1,sc);
% PURPOSE: Accumulate within a period of sc observations
% ------------------------------------------------------------
% SYNTAX: za = temporal_acc(z,op1,sc);
% ------------------------------------------------------------
% OUTPUT: za: nx1 accumulated vector
% ------------------------------------------------------------
% INPUT:  op1: type of temporal aggregation 
%         op1=1 ---> sum (flow)
%         op1=2 ---> average (index)
%         sc: number of high frequency data points 
%            for each low frequency data points (freq. conversion)
% ------------------------------------------------------------
% LIBRARY: acc
% ------------------------------------------------------------
% SEE ALSO: temporal_agg
% ------------------------------------------------------------

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 1.0 [May 2009]

% Dimension of input data
n = length(z);

% Computing implicit numer of low-frequency data
N = fix(n/sc);

% Generating accumulation matrix
A = acc(op1,n,sc);

% Computing accumulated time series
za = A * z;

