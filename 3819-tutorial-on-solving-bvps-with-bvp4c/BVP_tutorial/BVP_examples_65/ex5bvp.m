function ex5bvp
%EX5BVP  Example 5 of the BVP tutorial.
%   Falkner-Skan BVPs are discussed in T. Cebeci and H.B. Keller, 
%   Shooting and parallel shooting methods for solving the Falkner-Skan
%   boundary-layer equation, J. Comp. Phy., 7 (1971) 289-300.  This is 
%   the positive wall shear case for which the parameter beta is known 
%   and the problem is to be solved for a range of the parameter.  This
%   is the hardest case of the table in the paper.
%
%   The problem is posed on [0 infinity).  As in the paper cited, the
%   boundary condition at infinity is imposed at a finite point, here
%   called 'infinity'.  It is best to start with a relatively small value
%   and increase it until consistent results are obtained.  A value of 6
%   appears to be satisfactory.  Starting with a "large" value is tempting,
%   but not a good tactic because the code will fail with the crude guess
%   and default tolerances used here.

% Copyright 2002, The MathWorks, Inc.

%  'infinity' is a variable to facilitate experimentation.
infinity = 6;

%  The constant guess for the solution satisfies the boundary conditions.
solinit = bvpinit(linspace(0,infinity,5),[0 0 1]);

options = bvpset('stats','on');

sol = bvp4c(@ex5ode,@ex5bc,solinit,options);
eta = sol.x;
f = sol.y;

fprintf('\n');
fprintf('Cebeci & Keller report f''''(0) = 0.92768.\n')
fprintf('Value computed here is f''''(0) = %7.5f.\n',f(3,1))

figure
plot(eta,f(2,:));
axis([0 infinity 0 1.4]);
title('Falkner-Skan equation, positive wall shear, \beta = 0.5.')
xlabel('\eta')
ylabel('df/d\eta')

% --------------------------------------------------------------------------

function dfdeta = ex5ode(eta,f)
%EX5ODE  ODE function for Example 5 of the BVP tutorial.   
beta = 0.5;
dfdeta = [ f(2)
           f(3)
          -f(1)*f(3) - beta*(1 - f(2)^2) ];

% --------------------------------------------------------------------------

function res = ex5bc(f0,finf)
%EX5BC  Boundary conditions for Example 5 of the BVP tutorial.
res = [f0(1)
       f0(2)
       finf(2) - 1];
