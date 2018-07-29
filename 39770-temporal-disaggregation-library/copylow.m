function [z] = copylow(Z,op1,sc)
% PURPOSE: Generates a high-frequency time series from a low-frequency one
% -----------------------------------------------------------------------------
% SYNTAX: z = copylow(Z,op1,sc);
% -----------------------------------------------------------------------------
% OUTPUT: z : nxk high frequency time series
% -----------------------------------------------------------------------------
% INPUT: Z     : an Nxk matrix of low frequency series, columnwise
%        op1   : type of temporal aggregation 
%        op1=1 ---> copy sc times the lf data
%        op1=2 ---> copy sc times the mean lf data
%        op1=3 ---> last element (stock) ---> interpolation
%        op1=4 ---> first element (stock) ---> interpolation
%        sc: number of high frequency data points 
%        for each low frequency data points (quarterly: sc=4, monthly: sc=12)
% -----------------------------------------------------------------------------
% LIBRARY: 
% -----------------------------------------------------------------------------
% SEE ALSO: temporal_agg
% -----------------------------------------------------------------------------

% written by:
% Ana Abad(*) & Enrique M. Quilis(**)
%  (*) National Statistical Institute
%  (**) Macroeconomic Research Department
%       Ministry of Economy and Competitiveness
%       <enrique.quilis@mineco.es>

% Version 1.1 [August 2006]

% ------------------------------------------------------------
% Dimension of input data

[N,k] = size(Z);

% ------------------------------------------------------------
% Generation of disaggregation matrix 

c = aggreg_v(op1,sc);

% ------------------------------------------------------------
% Temporal copy-interpolation matrix

n = sc*N;

C = kron(eye(N),c');

% ------------------------------------------------------------
% Temporal disaggregation of a vector of time series

z = zeros(n,k);  %Preallocation

for j=1:k
    z(:,j) = C * Z(:,j);
end

