function [S] = movingsum(h,n)
% PURPOSE: Accumulates h consecutive periods of a vector nx1
% ------------------------------------------------------------
% SYNTAX: S = movingsum(h,n);
% ------------------------------------------------------------
% OUTPUT: S: (n-h)xn moving aggregation matrix
% ------------------------------------------------------------
% INPUT:  
%        h : size of consecutive aggregation
%        n : dimension of filter matrix 
% ------------------------------------------------------------
% NOTE: The U(B) filter of degree h-1 performs a moving sum of h
% consecutive elements of time series vector.
% Its matrix form has n columns (since it is applied to the whole
% vector) and n-h+1 rows, due to the missing values induced by the
% absence of h-1 initial conditions (note that U(B) has degree h-1).

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 1.1 [August 2006]

c = ones(1,h);

S = [c zeros(1,n-h)];  % Initial condition
for i=2:n-h+1
   S = [ S
          zeros(1,i-1) c zeros(1,n-h-i+1)];
end
