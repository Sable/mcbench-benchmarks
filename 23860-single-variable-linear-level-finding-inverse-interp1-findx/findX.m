%FINDX Single-variable linear level finding ("inverse" INTERP1).
%   XI = findX(X,Y,YI) estimates the XI values at which the dependent
%   variables Y reach or cross a specified target level YI (scalar value).
%   If there are multiple solutions, findX finds all of them.
%   It may be seen as the "inverse" operation of the MATLAB's function
%   INTERP1, under 'linear' method.
%
%   X is a vector containing a sequence of monotone increasing values of
%   the independent variable. Y is a vector containing the discrete values
%   of the dependent variable (underlying function).
%
%   [XI,IDEXACT] = findX(X,Y,YI) returns in IDEXACT the indices where the
%   original values of Y exactly reach the target level YI,
%   i.e. Y(IDEXACT)=YI, so interpolation was not needed.
%
% Antoni J. Canos.
% Microwave Heating Group, GEA.
% ITACA, Technical University of Valencia.
% Valencia (Spain), April 2009

function [XI,IDEXACT] = findX(X,Y,YI)

% Check dimensions of input arrays
m=length(X);
r=length(Y);

if ~isvector(X) | ~isvector(Y)
    error('X and Y must be vectors.');
end

if (m ~= r)
    error('Lengths of X and Y vectors must be the same.');
end

% Initialize outputs
XI = [];
IDEXACT = [];
IDINTERP = [];

% Subtract target level to simplify subsequent code
Y = Y - YI;

% Find exact values. They can be crossings or "kisses".
IDEXACT = find(Y==0);

% Find crossings
IDINTERP = find ( Y(1:end-1) .* Y(2:end) < 0 );

% Calculating XI values and combining
XI = union(X(IDEXACT),X(IDINTERP) + (X(IDINTERP+1) - X(IDINTERP)) .* Y(IDINTERP) ./ (Y(IDINTERP) - Y(IDINTERP+1)));

