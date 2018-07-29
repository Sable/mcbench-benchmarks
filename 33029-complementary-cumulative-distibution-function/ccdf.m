function [y,range]=ccdf(x,step);
% CCDF Complementary Cumulative Distribution Function of an array of numbers.
% Y = CCDF(X,STEP) returns an array of values of the complementary cumulative
% distribution function for the N-Dimentional array X, calculated for each
% element of the 1-Dimentional array RANGE which ranges from min(X) to max(X).
% STEP is a scalar that determines increment in the values of RANGE and hence
% the smoothness of Y.
%
% [Y,RANGE] = CCDF(X,STEP) also returns the array RANGE.

%   See also 

%   Copyright        The MathWorks, Inc.
%   $Revision:           $  $Date:            $


if nargin<2
    error('not enough number of inputs')
end
N=length(x);
range=min(x):step:max(x);
y=[];
for i=range
    y=[y length(find(x>i))/N];
end

