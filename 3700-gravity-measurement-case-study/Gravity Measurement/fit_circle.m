% fit_circle.m

%fit circle to set of positions

% Eq1: (X-x0)^2 + (Y-y0)^2 = r0^2
% Eq2: (-2*x0)*X + (-2*y0)*Y + (x0^2 + y0^2 - r0^2) = -(X^2 + Y^2)
% Eq3: [X Y 1] * [-2*x0; -2*y0; x0^2+y0^2-r0^2] = -(X^2+Y^2)
% Eq4: A*x = b

% Copyright 2003-2010 The MathWorks, Inc.

% substitute:
A = [X(:) Y(:) ones(size(X(:)))];
b = -(X(:).^2+Y(:).^2);

% solve:
x = A\b;

% back calculate parameters
x0 = -x(1)/2;
y0 = -x(2)/2;
r0 = sqrt(x0^2 + y0^2 - x(3));

%draw fitted circular arc through data points
[x_lo,i1]=min(X); th1=atan2(Y(i1)-y0,X(i1)-x0);
[x_hi,i2]=max(X); th2=atan2(Y(i2)-y0,X(i2)-x0);
th=linspace(th1,th2,100);
[xx,yy]=pol2cart(th,r0*ones(size(th)));
figure(myFig)
line(xx+x0+x1,yy+y0+y1,'color','m')
line([X(i1) x0 X(i2)]+x1,[Y(i1) y0 Y(i2)]+y1,'color','g')
axis tight
title(sprintf('Center = (%.1f,%.1f), Radius = %.1f pixels',x0,y0,r0))
