function [minx, maxx] = extrema(x)
%EXTREMA    extremal values within 2D cell or numerical array.
%   [minx, maxx] = EXTREMA(x) returns the minimum and maximum values of x
%   in minx and maxx, respectively. Argument x may be either a 2D numeric
%   matrix, or a 2D cell array, containing other 2D cell or numeric arrays
%   within it (or a mix). The search is performed by recursive calls of
%   the min_cell and max_cell functions.
%
%   See also MIN_CELL, MAX_CELL.
%
% File:      extrema.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2012.01.22
% Language:  MATLAB R2011b
% Purpose:   Extremal values in 2D Cell/Numeric Matrix
% Copyright: Ioannis Filippidis, 2012-

minx = min_cell(x);
maxx = max_cell(x);
