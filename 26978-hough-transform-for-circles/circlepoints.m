function [x, y] = circlepoints(r)
%CIRCLEPOINTS  Returns integer points close to a circle
%   [X, Y] = CIRCLEPOINTS(R) returns coordinates of integer points close to
%   a circle of radius R, such that none is repeated and there are no gaps
%   in the circle (under 8-connectivity).

%   Copyright David Young 2010

% Get number of rows needed to cover 1/8 of the circle
l = round(r/sqrt(2));
if round(sqrt(r.^2 - l.^2)) < l   % if crosses diagonal
    l = l-1;
end
% generate coords for 1/8 of the circle, a dot on each row
x0 = 0:l;
y0 = round(sqrt(r.^2 - x0.^2));
% Check for overlap
if y0(end) == l
    l2 = l;
else
    l2 = l+1;
end
% assemble first quadrant
x = [x0 y0(l2:-1:2)]; 
y = [y0 x0(l2:-1:2)];
% add next quadrant
x0 = [x y];
y0 = [y -x];
% assemble full circle
x = [x0 -x0];
y = [y0 -y0];
end