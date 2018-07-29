function [xi,yi] = snakeinterp(x,y,dmax,dmin)
%SNAKEINTERP  Interpolate the snake adaptively
%   [xi,yi] = snakeinterp(x,y,dmax,dmin)
%
%   dmax: the maximum distance between two snake points
%   dmin: the maximum distance between two snake points
%   d(i,i+1)>dmax, then a new point is added between i and i+1
%   d(i,i+1)<dmin, then either i or i+1 is removed 
%  
%   NOTE: the spacing of original curve must be close to the 
%         range defined by dmax and dmin. For arbitrary spacing,
%         try snakeinterp1.
% 
%   See also SNAKEINTERP1

%    there is a bug in the program for points removal

%   Chenyang Xu and Jerry L. Prince, 4/1/95, 6/17/97
%   Copyright (c) 1995-97 by Chenyang Xu and Jerry L. Prince
%   Image Analysis and Communications Lab, Johns Hopkins University
    xi=x;
    yi=y;
% convert to column vector
x = x(:); y = y(:);

N = length(x);

d = abs(x([2:N 1])- x(:)) + abs(y([2:N 1])- y(:));

% remove the points which distance to neighbor points is shorter than dmin
IDX = (d<dmin);

idx = find(IDX==0);
x = x(idx);
y = y(idx);

N = length(x);

if N>0
    
    d = abs(x([2:N 1])- x(:)) + abs(y([2:N 1])- y(:));
    
    IDX = (d>dmax);
    
    z = snakeindex(IDX);
    
    p = 1:N+1;
    
    xi = interp1(p,[x;x(1)],z');
    yi = interp1(p,[y;y(1)],z');
    
    N = length(xi);
    d = abs(xi([2:N 1])- xi(:)) + abs(yi([2:N 1])- yi(:));
    
    while (max(d)>dmax),
        
        IDX = (d>dmax);
        z = snakeindex(IDX);
        
        p = 1:N+1;
        
        xi = interp1(p,[xi;xi(1)],z');
        yi = interp1(p,[yi;yi(1)],z');
        
        N = length(xi);
        d = abs(xi([2:N 1])- xi(:)) + abs(yi([2:N 1])- yi(:));
    end
    


end