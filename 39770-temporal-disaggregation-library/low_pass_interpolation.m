function [y,w,x] = low_pass_interpolation(Y,ta,d,sc,lambda);
% PURPOSE: Low-pass interpolation using Hodrick-Prescott and Denton
% -----------------------------------------------------------------------
% SYNTAX: [y,w,x] = low_pass_interpolation(Y,ta,d,sc,lambda);
% -----------------------------------------------------------------------
% OUTPUT: y: nx1 ---> final interpolation
%         w: nx1 ---> intermediate interpolation (low-pass filtering of x)
%         x: nx1 ---> initial interpolation (padding Y with zeros)
% -----------------------------------------------------------------------
% INPUT: Y: Nx1 ---> vector of low frequency data
%        ta: 1x1 type of disaggregation
%            ta=1 ---> sum (flow)
%            ta=2 ---> average (index)
%            ta=3 ---> last element (stock) ---> interpolation
%            ta=4 ---> first element (stock) ---> interpolation
%        d: 1x1 objective function to be minimized: volatility of ...
%            d=0 ---> levels
%            d=1 ---> first differences
%            d=2 ---> second differences
%        sc: 1x1 number of high frequency data points for each low frequency data point
%            sc= 4 ---> annual to quarterly
%            sc=12 ---> annual to monthly
%            sc= 3 ---> quarterly to monthly
%        lambda: 1x1 --> balance between adjustment and smoothness (HP
%        low-pass filter)
% -----------------------------------------------------------------------
% LIBRARY: copylow, hp, denton_uni
% -----------------------------------------------------------------------
% SEE ALSO: bfl, sw
% -----------------------------------------------------------------------

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 1.1 [January 2013]

% ---------------------------------------------------------------------
% (1): Raw interpolation: padding Y with zeros and scaling (Y*s)
x = copylow(sc*Y,3,sc);

% ---------------------------------------------------------------------
% (2): Low-pass smoothing by means of Hodrick-Prescott filter
w = hp(x,lambda);

% ---------------------------------------------------------------------
% (3): Enforce consistency with annual counterpart by means of benchmarking
% (Denton, additive variant).
% Calling the function: output is loaded in a structure called res.
op1 = 1; %Additive Denton.
rex = denton_uni(Y,w,ta,d,sc,op1);
y = rex.y;

