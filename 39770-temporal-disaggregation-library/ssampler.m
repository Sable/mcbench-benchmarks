function [zs] = ssampler(z,op1,sc)
% PURPOSE: Systematic sampling of a high-frequency time series
% ------------------------------------------------------------
% SYNTAX: zs = ssampler(z,op1,sc)
% ------------------------------------------------------------
% OUTPUT: zs: nx1 sampled time series
% ------------------------------------------------------------
% INPUT:  z: nx1 ---> vector of high frequency data
%         op1: type of temporal aggregation 
%         op1=1 ---> sum (flow)
%         op1=2 ---> average (index)
%         op1=3 ---> last element (stock) ---> interpolation
%         op1=4 ---> first element (stock) ---> interpolation
%         sc: number of high frequency data points 
%            for each low frequency data points
% ------------------------------------------------------------
% LIBRARY: copylow, temporal_agg
% ------------------------------------------------------------

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 1.0 [May 2009]

aux = temporal_agg(z,op1,sc);
zs = copylow(aux,3,sc);
