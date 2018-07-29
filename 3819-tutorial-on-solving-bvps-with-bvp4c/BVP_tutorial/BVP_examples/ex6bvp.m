function ex6bvp
%EX6BVP  Example 6 of the BVP tutorial.
%   This is Example 2 from M. Kubicek et alia, Test examples for comparison 
%   of codes for nonlinear boundary value problems in ordinary differential 
%   equations, B. Childs et al., eds., Codes for Boundary-Value Problems in 
%   Ordinary Differential Equations, Lecture Notes in Computer Science #76, 
%   Springer, New York, 1979.  This example shows how to deal with a singular
%   coefficient arising from reduction of a partial differential equation to
%   an ODE by symmetry.  Also, for the physical parameters considered here,
%   the problem has three solutions.

% Copyright 1999, The MathWorks, Inc.

%  Define the physical parameters for this problem.
f = 0.6;
g = 40;
b = 0.2;

options = [];  % place holder

guess  = [1; 0.5; 0];
others = [0.9070; 0.3639; 0.0001];      % Values reported by Kubicek et alia.

fprintf('y(0):  bvp4c    Kubicek et al.\n')
clf reset

for index = 1:3
  solinit = bvpinit(linspace(0,1,5),[guess(index) 0]);
  sol = bvp4c(@ex6ode,@ex6bc,solinit,options,f,g,b);
  
  fprintf('      %6.4f       %6.4f\n',sol.y(1,1),others(index))
  plot(sol.x,sol.y(1,:))
  if index == 1
    axis([0 1 -0.1 1.1])
    title('Multiple solutions to spherical catalyst problem.')
    xlabel('x')
    ylabel('y')
    hold on
    shg
  end
  drawnow
end
hold off

% --------------------------------------------------------------------------

function dydx = ex6ode(x,y,f,g,b)
%EX6ODE  ODE function for Example 6 of the BVP tutorial.
dydx = [y(2); 0];
temp = f^2 * y(1) * exp(g*b*(1-y(1))/(1+b*(1-y(1))));
if x == 0
  dydx(2) = (1/3)*temp;
else
  dydx(2) = -(2/x)*y(2) + temp;
end

% --------------------------------------------------------------------------

function res = ex6bc(ya,yb,f,g,b)
%EX6BC  Boundary conditions for Example 6 of the BVP tutorial.
res = [ ya(2)
        yb(1) - 1];     
 
     
