function ex4bvp
%EX4BVP  Example 4 of the BVP tutorial.
%   This is a nerve impulse model considered in Example 7.1 of
%   R. Seydel, From Equilibrium to Chaos, Elsevier, 1988.  The
%   differential equations
%
%      y1' = 3*(y1 + y2 - 1/3*y1^3 + lambda)
%      y2' = -(y1 - 0.7 + 0.8*y2)/3
%
%   are to be solved subject to periodic boundary conditions
%
%      y1(0) = y1(T)
%      y2(0) = y2(T)
%
%   This is an example of non-separated boundary conditions, meaning
%   that some conditions involve values of the solution at both ends
%   of the interval.  Periodic boundary conditions are a common source
%   of such problems.  BVP4C is unusual in that it accepts problems
%   with non-separated boundary conditions.
%
%   The parameter lambda has the value -1.3 in the text cited.  The
%   period T is unknown, which is to say that the length of the 
%   interval is not known. Such problems require some preparation. 
%   By scaling the independent variable to tau = t/T the problem is 
%   posed on the fixed interval [0,1]. When this is done, T becomes 
%   an unknown parameter, but BVP4C provides for unknown parameters.

% Copyright 1999, The MathWorks, Inc.

%  Periodic functions evaluated in EX4INIT are used as a guess for the
%  solution on a crude mesh of 5 equally spaced points.  A guess of 2*pi 
%  is provided for the unknown parameter T.
solinit = bvpinit(linspace(0,1,5),@ex4init,2*pi);

options = bvpset('stats','on');

sol = bvp4c(@ex4ode,@ex4bc,solinit,options);
T = sol.parameters;

%  The independent variable needs to be rescaled to its original value
%  before plotting the solution.  The initial guess is also plotted.
clf reset
plot(T*sol.x,sol.y(1,:),T*solinit.x,solinit.y(1,:),'o')
legend('solution found','initial guess');
axis([0 T -2.2 2]);
title('Nerve impulse model');
ylabel('solution y_1(t)');
xlabel(['Periodic solution with period ',num2str(sol.parameters,4)]);
shg

% --------------------------------------------------------------------------

function v = ex4init(x)
%EX4INIT  Guess function for Example 4 of the BVP tutorial.
%   V = EX4INIT(X) returns a column vector V that is a guess for y(x).
v = [ sin(2*pi*x) 
      cos(2*pi*x)];

% --------------------------------------------------------------------------

function dydt = ex4ode(t,y,T);
%EX4ODE  ODE funcion for Example 4 of the BVP tutorial.
dydt = [ 3*T*(y(1) + y(2) - 1/3*(y(1)^3) - 1.3);
         (-1/3)*T*(y(1) - 0.7 + 0.8*y(2)) ];

% --------------------------------------------------------------------------

function res = ex4bc(ya,yb,T)
%EX4BC  Boundary conditions for Example 4 of the BVP tutorial.
res = [ya(1) - yb(1)
       ya(2) - yb(2)
       T*(-1/3)*(ya(1) - 0.7 + 0.8*ya(2)) - 1]; 
     