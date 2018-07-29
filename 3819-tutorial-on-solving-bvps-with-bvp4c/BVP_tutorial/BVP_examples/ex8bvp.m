function ex8bvp
%EX8BVP  Example 8 of the BVP tutorial.
%   These are equations describing fluid injection through one side of
%   a long  vertical channel, considered in Example 1.4 of U.M. Ascher, 
%   R.M.M. Mattheij, and R.D. Russell, Numerical Solution of Boundary 
%   Value Problems for Ordinary Differential Equations, SIAM, 1995
%
%   The differential equations
%
%      f''' - R*[(f')^2 - f*f''] + R*A = 0
%      h'' + R*f*h' + 1 = 0
%      theta'' + P*f*theta' = 0
%
%   are to be solved subject to boundary conditions
%
%      f(0) = f'(0) = 0
%      f(1) = 1
%      f'(1) = 0
%      h(0) = h(1) = 0
%      theta(0) = 0
%      theta(1) = 1
%
%   Here R and P are known constants, but A is determined by the boundary 
%   conditions.
%
%   For a Reynolds number R = 100, this problem can be solved with crude
%   guesses, but as R increases, it becomes much more difficult because of
%   a boundary layer at x = 0.  The solution is computed here for R = 10000
%   by continuation, i.e., the solution for one value of R is used as guess
%   for R = R*10.  This is a comparatively expensive problem for BVP4C because
%   a fine mesh is needed to resolve the boundary layer and there are 7 
%   unknown functions and 1 unknown parameter.

% Copyright 1999, The MathWorks, Inc.

% The solution is first sought for R = 100.
R = 100;

options = [];    % place holder

% A crude mesh of 10 equally spaced points and a constant 1 
% for each solution component is used for the first value of R.
% The unknown parameter A is guessed to be 1.
solinit = bvpinit(linspace(0,1,10),ones(7,1),1);

sol = bvp4c(@ex8ode,@ex8bc,solinit,options,R);

fprintf('For R = %5i, A = %4.2f.\n',R,sol.parameters);
clf reset
lines = {'k-.','r--','b-'};
plot(sol.x,sol.y(2,:),lines{1});
axis([-0.1 1.1 0 1.7]);
title('Fluid injection problem');
xlabel('x');
ylabel('f'' (x)');
drawnow

% The solution is computed for larger R by continuation, i.e.,
% the solution for one value of R is used as guess for the next.
hold on
for i=2:3
  R = R*10;
  sol = bvp4c(@ex8ode,@ex8bc,sol,options,R);
  fprintf('For R = %5i, A = %4.2f.\n',R,sol.parameters);
  plot(sol.x,sol.y(2,:),lines{i});
  drawnow
end
legend('R =    100','R =   1000','R = 10000',1); 
hold off

% --------------------------------------------------------------------------

function dydx = ex8ode(x,y,A,R);
%EX8ODE  ODE function for Example 8 of the BVP tutorial.
P = 0.7*R;
dydx = [ y(2)
         y(3)
         R*(y(2)^2 - y(1)*y(3) - A)
         y(5)
        -R*y(1)*y(5) - 1
         y(7)
        -P*y(1)*y(7) ];

% --------------------------------------------------------------------------

function res = ex8bc(ya,yb,A,R)
%EX8BC  Boundary conditions for Example 8 of the BVP tutorial.
res = [ya(1)
       ya(2)
       yb(1) - 1
       yb(2)
       ya(4)
       yb(4)
       ya(6)
       yb(6) - 1];

