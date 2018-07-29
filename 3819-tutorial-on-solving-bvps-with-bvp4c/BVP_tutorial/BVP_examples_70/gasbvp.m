function gasbvp
%GASBVP  Exercise for Example 5 of the BVP tutorial.
%   Example 8.4 of P.B. Bailey, L.F. Shampine, and P.E. Waltman, 
%   Nonlinear Two Point Boundary Value Problems, Academic, New York,
%   1968.  This is a problem on an infinite interval with a parameter
%   alpha here taken to be 0.8.  w(z) should decrease monotonely
%   from 1 to 0.

% Copyright 2004, The MathWorks, Inc.

infinity = 3;

options = bvpset('stats','on');

solinit = bvpinit(linspace(0,infinity,5),[0.5 -0.5]);
sol = bvp4c(@gasode,@gasbc,solinit,options);
z = sol.x;
w = sol.y;

figure
plot(z,w(1,:));
axis([0 infinity 0 1]);
xlabel('z');
ylabel('w');
title('Unsteady gas flow in a semi-infinite porous medium.');

% --------------------------------------------------------------------------

function dydz = gasode(z,y)
%GASODE  ODE function for the exercise of Example 5 of the BVP tutorial.
alpha = 0.8;
dydz =  [  y(2)
          -y(2)*2*z / sqrt(1 - alpha*y(1)) ];

% --------------------------------------------------------------------------

function res = gasbc(ya,yb)
%GASBC  Boundary conditions for the exercise of Example 5 of the BVP tutorial.
res = [ ya(1) - 1 
        yb(1)     ];
