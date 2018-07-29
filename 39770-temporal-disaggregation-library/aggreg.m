function [C] = aggreg(op1,N,sc)
% PURPOSE: Generate a temporal aggregation matrix
% ------------------------------------------------------------
% SYNTAX: C = aggreg(op1,N,sc);
% ------------------------------------------------------------
% OUTPUT: C: N x (sc x N) temporal aggregation matrix
% ------------------------------------------------------------
% INPUT:  op1: type of temporal aggregation 
%         op1=1 ---> sum (flow)
%         op1=2 ---> average (index)
%         op1=3 ---> last element (stock) ---> interpolation
%         op1=4 ---> first element (stock) ---> interpolation
%         N: number of low frequency data
%         sc: number of high frequency data points 
%            for each low frequency data points (freq. conversion)
% ------------------------------------------------------------
% LIBRARY: aggreg_v
% ------------------------------------------------------------
% SEE ALSO: temporal_agg
% ------------------------------------------------------------
% NOTE: Use aggreg_v_X for extended interpolation

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 1.1 [August 2006]

% ------------------------------------------------------------
% Generation of aggregation matrix C=I(N) <kron> c

c = aggreg_v(op1,sc);

% ------------------------------------------------------------
% Temporal aggregation matrix

C = kron(eye(N),c);

