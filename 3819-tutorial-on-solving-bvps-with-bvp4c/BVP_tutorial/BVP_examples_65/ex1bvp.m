function ex1bvp
%EX1BVP  Example 1 of the BVP tutorial.
%   This is the example for MUSN in U. Ascher, R. Mattheij, and R. Russell, 
%   Numerical Solution of Boundary Value Problems for Ordinary Differential 
%   Equations, SIAM, Philadelphia, PA, 1995.  MUSN is a multiple shooting 
%   code for nonlinear BVPs.  The problem is
%   
%      u' =  0.5*u*(w - u)/v
%      v' = -0.5*(w - u)
%      w' = (0.9 - 1000*(w - y) - 0.5*w*(w - u))/z
%      z' =  0.5*(w - u)
%      y' = -100*(y - w)
%   
%   The interval is [0 1] and the boundary conditions are
%   
%      u(0) = v(0) = w(0) = 1,  z(0) = -10,  w(1) = y(1)
%   
%   The example uses a guess for the solution coded here in EX1INIT.  
%   The results of a run of the FORTRAN code MUSN are here compared to
%   the curves produced by BVP4C.  

% Copyright 2002, The MathWorks, Inc.

solinit = bvpinit(linspace(0,1,5),@ex1init);
options = bvpset('Stats','on','RelTol',1e-5);

sol = bvp4c(@ex1ode,@ex1bc,solinit,options);

% The solution at the mesh points
x = sol.x;
y = sol.y;

% Solution obtained using MUSN:
amrx = [ 0. .1 .2 .3 .4 .5 .6 .7 .8 .9 1.]';
amry = [1.00000e+00   1.00000e+00   1.00000e+00  -1.00000e+01   9.67963e-01
        1.00701e+00   9.93036e-01   1.27014e+00  -9.99304e+00   1.24622e+00
        1.02560e+00   9.75042e-01   1.47051e+00  -9.97504e+00   1.45280e+00
        1.05313e+00   9.49550e-01   1.61931e+00  -9.94955e+00   1.60610e+00
        1.08796e+00   9.19155e-01   1.73140e+00  -9.91915e+00   1.72137e+00
        1.12900e+00   8.85737e-01   1.81775e+00  -9.88574e+00   1.80994e+00
        1.17554e+00   8.50676e-01   1.88576e+00  -9.85068e+00   1.87957e+00
        1.22696e+00   8.15025e-01   1.93990e+00  -9.81503e+00   1.93498e+00
        1.28262e+00   7.79653e-01   1.98190e+00  -9.77965e+00   1.97819e+00
        1.34161e+00   7.45374e-01   2.01050e+00  -9.74537e+00   2.00827e+00
        1.40232e+00   7.13102e-01   2.02032e+00  -9.71310e+00   2.02032e+00];

% Shift up the fourth component for the plot.
amry(:,4) = amry(:,4) + 10;
y(4,:) = y(4,:) + 10;

figure
plot(x,y',amrx,amry,'*')
axis([0 1 -0.5 2.5])
title('Example problem for MUSN')
ylabel('bvp4c and MUSN (*) solutions')
xlabel('x')

% --------------------------------------------------------------------------

function dydx = ex1ode(x,y)
%EX1ODE  ODE function for Example 1 of the BVP tutorial.
%   The components of y correspond to the original variables
%   as  y(1) = u, y(2) = v, y(3) = w, y(4) = z, y(5) = y.
dydx =  [ 0.5*y(1)*(y(3) - y(1))/y(2)
         -0.5*(y(3) - y(1))
         (0.9 - 1000*(y(3) - y(5)) - 0.5*y(3)*(y(3) - y(1)))/y(4)
          0.5*(y(3) - y(1))
          100*(y(3) - y(5)) ];

%-------------------------------------------------------------------------

function res = ex1bc(ya,yb)
%EX1BC  Boundary conditions for Example 1 of the BVP tutorial.
%   RES = EX1BC(YA,YB) returns a column vector RES of the
%   residual in the boundary conditions resulting from the
%   approximations YA and YB to the solution at the ends of 
%   the interval [a b]. The BVP is solved when RES = 0. 
%   The components of y correspond to the original variables
%   as  y(1) = u, y(2) = v, y(3) = w, y(4) = z, y(5) = y.
res = [ ya(1) - 1
        ya(2) - 1
        ya(3) - 1
        ya(4) + 10
        yb(3) - yb(5)];

%-------------------------------------------------------------------------

function v = ex1init(x)
%EX1INIT  Guess for the solution of Example 1 of the BVP tutorial.
v = [        1 
             1
     -4.5*x^2+8.91*x+1
            -10
     -4.5*x^2+9*x+0.91 ];

