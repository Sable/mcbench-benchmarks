function y = linspace3(d1, tar, d2, n)
%LINSPACE3 bilinearly spaced vector defined by three points.
%   LINSPACE3(X1, X2, X3) generates a row vector of 100 points between X1
%   and X3 as linearly spaced as possible such that the vector contains X2.
%
%   LINSPACE3(X1, X2, X3, N) generates a row vector of N points.
% 
%   LINSPACE3 will always contain X1, X2, and X3 without repeating an
%   element.
% 
%   For N < 3, LINSPACE3 returns the shortest possible vector containing
%   all of X1, X2, and X3. This is normally [X1 X2 X3]. However, if X1=X2
%   or X2=X3, LINSPACE3 returns [X1 X3].
% 
%   Given an even split, LINSPACE3 will put the extra element below X2.
%   (LINSPACE3(0, 2, 4, 4) yields [0 1 2 4])
% 
%   Author:     Sky Sartorius
%
%   See also COSSPACE, SINSPACE, LINSPACE, LOGSPACE.

if nargin == 3
    n = 100;
end

loc = (tar-d1)/(d2-d1);
if (loc > 1) || loc < 0
    error('X2 must lie between X1 and X2')
end

spacebelow = round((n-1)*loc);
nbelow = spacebelow+1;
nabove = n-spacebelow;

if nbelow < 2
    if d1 == tar
        y1 = d1;
    else
        y1 = [d1 tar];
        nabove = nabove - 1;
    end
end
    
if nabove < 2
    if tar == d2
        y2 = d2;
    else
        y2 = [tar d2];
        nbelow = nbelow - 1;
    end
end

if nbelow >= 2
    y1 = [d1+(0:nbelow-2)*(tar-d1)/(nbelow-1) tar];
end
if nabove >= 2
    y2 = [tar+(0:nabove-2)*(d2-tar)/(nabove-1) d2];
end

if y1(end) == y2(1);
    y1(end) = [];
end
y = [y1 y2];
end

