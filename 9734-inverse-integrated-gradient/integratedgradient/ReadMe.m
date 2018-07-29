%{ Use of this suite of codes requires that you put the main directory
(integratedgradient) on your search path.

I'll comment that intgrad1 was written mainly to test ideas in
building intgrad2 and intgrad3. It does have some value anyway, as
an accurate cumulative integration tool. I've put 5 different methods
in there, but I'd probably suggest usage of the default method. It
seems to offer the best combination of speed and accuracy.

Author; John D'Errico
Current release: 2
Date of release: 1/27/06


Comparisons and example usages:

%}

%%

% simple, uniform spacing 1-d cumulative integral on 101 points
xp = 0:.01:1;
f = exp(xp);
fx = exp(xp); % a simple derivative to evaluate

%%

% using cumulative trapezoidal rule
tic,fhat = intgrad1(fx,xp,1,0);toc
% Elapsed time is 0.002617 seconds.

std(f-fhat)
% ans =
%    4.1639e-06

%%

% Second order finite difference solution
tic,fhat = intgrad1(fx,xp,1,1);toc
% Elapsed time is 0.027696 seconds.

std(f-fhat)
% ans =
%   8.3252e-06

%%

% Cubic spline integral
tic,fhat = intgrad1(fx,xp,1,2);toc
% Elapsed time is 0.011760 seconds.

std(f-fhat)
% ans =
%   6.8725e-12

%%

% Pchip integral
tic,fhat = intgrad1(fx,xp,1,3);toc
% Elapsed time is 0.007235 seconds.

std(f-fhat)
% ans =
%   6.8934e-11

%%

% Fourth order finite difference solution
tic,fhat = intgrad1(fx,xp,1,4);toc
% Elapsed time is 0.035249 seconds.

std(f-fhat)
% ans =
%   1.6624e-10

%%

% In two dimensions, only a finite difference solution is available.
% It is both fast and good at integrating the gradient information.

% Example usage 1: (Note x is uniform in spacing, y is not.)
xp = 0:.1:1;
yp = [0 .1 .2 .4 .8 1];
[x,y]=meshgrid(xp,yp);
f = exp(x+y) + sin((x-2*y)*3);
[fx,fy]=gradient(f,.1,yp);
tic,fhat = intgrad2(fx,fy,.1,yp,1);toc
%  The time required was 0.053964 seconds

std(f(:)-fhat(:))
% ans =
%    1.066e-15


%%

% Example usage 2: Large grid, 101x101
xp = 0:.01:1;
yp = 0:.01:1;
[x,y]=meshgrid(xp,yp);
f = exp(x+y) + sin((x-2*y)*3);
[fx,fy]=gradient(f,.01);
tic,fhat = intgrad2(fx,fy,.01,.01,1);toc
%   Time required was 4.332 seconds

std(f(:) - fhat(:))
% ans =
%     1.066e-15

%%

% Moving into 3d, the linear algebra gets far more time consuming.
xp = linspace(0,1,10);
yp = linspace(0,1,20);
zp = linspace(0,1,30);
[x,y,z] = meshgrid(xp,yp,zp);
f = exp(x+y+z) + sin((x-2*y+3*z)*3);
[fx,fy,fz]=gradient(f,xp,yp,zp);
tic,fhat = intgrad3(fx,fy,fz,xp,yp,zp,1);toc
%   Time required was 51.4336 seconds

std(f(:)-fhat(:))
% ans =
%   7.7716e-15
