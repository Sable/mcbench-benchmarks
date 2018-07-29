function [A] = acc(op1,n,sc);
% PURPOSE: Generate an accumulation matrix
% ------------------------------------------------------------
% SYNTAX: [A] = acc(op1,n,sc); 
% ------------------------------------------------------------
% OUTPUT: A: nxn accumulation matrix
% ------------------------------------------------------------
% INPUT:  op1: type of temporal aggregation 
%         op1=1 ---> sum (flow)
%         op1=2 ---> average (index)
%         n: number of high frequency data
%         sc: number of high frequency data points 
%            for each low frequency data points (freq. conversion)
% ------------------------------------------------------------
% LIBRARY: aggreg
% ------------------------------------------------------------
% SEE ALSO: temporal_agg
% ------------------------------------------------------------

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 1.1 [May 2009]

% Computing implicit numer of low-frequency data
N = fix(n/sc);

% Auxiliary matrix
A1 = tril(ones(sc,sc));

% Selecting accumulation or averaging
switch op1
    case 1
        % Do nothing
    case 2
        A1 = A1 / sc;
    otherwise
        error ('*** Improper op1 ***');
end

% Accumulation matix
A = kron(eye(N),A1);

