function gZ = vrate(Z,s)
% PURPOSE: Compute the year-on-year rate of growth of a vector time series
% ------------------------------------------------------------------------
% SYNTAX:  gZ = vrate(Z,s);
% ------------------------------------------------------------
% OUTPUT: gZ: nxk --> yoy rate of growth. First s obs are NaN
% ------------------------------------------------------------
% INPUT:  Z: nxk --> vector time series to be filtered
%         s: 1x1 --> number of periods per year
% ------------------------------------------------------------
% LIBRARY: rate
% -----------------------------------------------------------------------

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 1.1 [August 2006]

[n,k] = size(Z);

% Preallocation
gZ = NaN * ones(n,k);

% Basic loop
for j=1:k
    gz = rate(Z(:,j),s);
    gZ(:,j) = gz;
end
