% TERNARY.COORDS calculate rectangular coordinates of fractions on a ternary plot
%   [X, Y] = TERNARY.COORDS(FA, FB) returns the rectangular X and Y coordinates
%   for the point with a fraction defined by FA and FB.  It is assumed that
%   FA and FB are sensible fractions.
%
%   [X, Y] = TERNARY.COORDS(FA, FB, FC) returns the same.  FC is assumed to be
%   the remainder when subtracting FA and FB from 1.

% Author: Carl Sandrock 20050211

% Modifications

% Modifiers

function [x, y] = coords(fA, fB, fC)
if nargin < 3
    fC = 1 - (fA + fB);
end

y = fB*sin(deg2rad(60));
x = fA + y*cot(deg2rad(60));%fA+fb*cos(deg2rad(60))
return
