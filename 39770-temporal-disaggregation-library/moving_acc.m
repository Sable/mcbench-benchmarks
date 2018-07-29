function [zs] = moving_acc(z,op1,sc);
% PURPOSE: Moving sum (average) with accumulation=sc
% ------------------------------------------------------------
% SYNTAX: zs = moving_acc(z,op1,sc);
% ------------------------------------------------------------
% OUTPUT: zs: nx1 moving sum (average) vector with (sc-1) initial zeros
% ------------------------------------------------------------
% INPUT:  op1: type of temporal aggregation 
%         op1=1 ---> sum (flow)
%         op1=2 ---> average (index)
%         sc: number of high frequency data points 
%            for each low frequency data points (freq. conversion) = size
%            of sum filter
% ------------------------------------------------------------
% LIBRARY: movingsum
% ------------------------------------------------------------
% SEE ALSO: temporal_acc, temporal_agg
% ------------------------------------------------------------

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 1.0 [May 2009]

% Dimension of input data
n = length(z);

% Defining matrix to perform moving sum
S = movingsum(sc,n);

% Transforming to moving average (if required)
switch op1
    case 1
        % Do nothing
    case 2
        % Moving average
        S = S / sc;
    otherwise
        error ('*** Improper op1 value ***');
end

% Transforming z
zs = S*z;

% Taking into account first (sc-1) missing values as zeros
zs = [zeros(sc-1,1) ; zs];


