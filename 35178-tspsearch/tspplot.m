function tspplot(p,X,nodenum) %#ok
%TSPPLOT Plot 2D tour
%   TSPPLOT(P,X), P is the tour and X is the coordinate matrix
%   TSPPLOT(P,X,1) also adds node numbers

%   Author: Jonas Lundgren <splinefit@gmail.com> 2012

x = X(p,1);
x = [x;x(1)];
y = X(p,2);
y = [y;y(1)];

% Plot
plot(x,y,'r',x,y,'k.')
grid
axis equal

% Add title
L = sqrt(diff(x).^2 + diff(y).^2);
str = sprintf('Tour Length: %g',sum(L));
title(str,'fonts',12)

% Add node numbers
if nargin > 2
    for k = 1:numel(p)
        str = sprintf(' %d',p(k));
        text(x(k),y(k),str)
    end
end
