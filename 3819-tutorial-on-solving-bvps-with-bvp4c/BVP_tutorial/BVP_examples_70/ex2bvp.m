function ex2bvp
%EX2BVP  Example 2 of the BVP tutorial.
%   A standard linear problem with a boundary layer at the origin.
%   The differential equation y'' + 3*p*y/(p + t^2)^2 = 0 has the 
%   analytical solution y(t) = t/sqrt(p + t^2).  The parameter p
%   is taken to be 1e-5, a common value in tests.  The solution is
%   to have specified values at t = -0.1 and +0.1, values taken from
%   this analytical solution.
%   
%   The default RelTol of 1e-3 gives an acceptable solution, but 
%   reducing RelTol to 1e-4 resolves better the boundary layer.  A 
%   constant guess is used for RelTol = 1e-3.  The same guess could be
%   used for RelTol = 1e-4, but a very much better guess is provided 
%   by the solution previously computed for RelTol = 1e-3.

% Copyright 2004, The MathWorks, Inc.

% Evaluate the analytical solution for comparison.
tt = -0.1:0.01:+0.1;
p = 1e-5;
yy = tt ./ sqrt(p + tt .^2);

options = bvpset('stats','on','Fjacobian',@ex2Jac);

% BVPINT is used to specify an initial guess for the mesh of 10
% equally spaced points.  A constant guess based on a straight line
% between the boundary values for y is 0 for y(t) and 10 for y'(t).
solinit = bvpinit(linspace(-0.1,0.1,10),[0 10]);

sol = bvp4c(@ex2ode,@ex2bc,solinit, options);
t = sol.x;
y = sol.y;

figure
plot(t,y(1,:),tt,yy,'*')
axis([-0.1 0.1 -1.1 1.1])
title(['Linear boundary layer problem with RelTol = 1e-3.'])
xlabel('t')
ylabel('y and analytical (*) solutions')

fprintf('\n');

% A smaller RelTol is used to resolve better the boundary layer.
% The previous solution provides an excellent guess.
options = bvpset(options,'RelTol',1e-4);
sol = bvp4c(@ex2ode,@ex2bc,sol,options);
t = sol.x;
y = sol.y;

figure
plot(t,y(1,:),tt,yy,'*')
axis([-0.1 0.1 -1.1 1.1])
title(['Linear boundary layer problem with RelTol = 1e-4.'])
xlabel('t')
ylabel('y and analytical (*) solutions')

% --------------------------------------------------------------------------

function dydt = ex2ode(t,y)
%EX2ODE  ODE function for Example 2 of the BVP tutorial.  
%   The components of y correspond to the original variables
%   as  y(1) = y, y(2) = y'.
p = 1e-5;
dydt = [ y(2)
        -3*p*y(1)/(p+t^2)^2];

% --------------------------------------------------------------------------

function dfdy = ex2Jac(t,y)
%EX2JAC  The Jacobian of the ODE function for Example 2 of the BVP tutorial.  
p = 1e-5;
dfdy = [          0        1
         -3*p/(p+t^2)^2    0 ];    

% --------------------------------------------------------------------------

function res = ex2bc(ya,yb)
%EX2BC  Boundary conditions for Example 2 of the BVP tutorial.
%   The boundary conditions are that the solution should agree
%   with the values of an analytical solution at both a and b.
p = 1e-5;
yatb = 0.1/sqrt(p + 0.01);
yata = - yatb;
res = [ ya(1) - yata
        yb(1) - yatb ];
