function ex3bvp
%EX3BVP  Example 3 of the BVP tutorial.
%   This is the example for D02KAF from the NAG library.  D02KAF is a code
%   for Sturm-Liouville problems that takes advantage of special features of
%   the problem.  The task is to find the fourth  eigenvalue of Mathieu's
%   equation 
%   
%      y'' + (lambda -2*q*cos(2*x))*y = 0
%   
%   on the interval [0, pi] with boundary conditions y'(0) = 0, y'(pi) = 0.
%   The parameter q = 5.
%   
%   A code that exploits fully the special nature of the Sturm-Liouville
%   problem can compute a specific eigenvalue.  Of course using BVP4C we can
%   only compute an eigenvalue near to a guessed value.  We can make it much
%   more likely that we compute the desired eigenfunction by supplying a
%   guess that has the correct qualitative behavior.  We use here the same
%   guess lambda = 15 as the example.  The eigenfunction is determined only
%   to a constant multiple, so the normalizing condition y(0) = 1 is used to
%   specify a particular solution.
%
%   Plotting the solution on the mesh found by BVP4C does not result in a
%   smooth graph.  The solution S(x) is continuous and has a continuous
%   derivative.  It can be evaluated inexpensively using BVPVAL at as many
%   points as necessary to get a smooth graph. 

% Copyright 1999, The MathWorks, Inc.

% BVPINT is used to form an initial guess for a mesh of 10 equally
% spaced points.  The guess cos(4x) for y(x) and its derivative as guess 
% for y'(x) are evaluated in EX3INIT.  The desired eigenvalue is the one
% nearest the guess lambda = 15.  A guess for unknown parameters is the
% (optional) last argument of BVPINIT.
solinit = bvpinit(linspace(0,pi,10),@ex3init,15);

options = bvpset('stats','on'); 

sol = bvp4c(@ex3ode,@ex3bc,solinit,options);

% BVP4C returns the solution as the structure 'sol'. The computed eigenvalue 
% is returned in the field sol.parameters.
fprintf('\n');
fprintf('D02KAF computed lambda = 17.097.\n')
fprintf('bvp4c  computed lambda =%7.3f.\n',sol.parameters)

clf reset
plot(sol.x,sol.y(1,:),sol.x,sol.y(1,:),'*')
axis([0 pi -1 1])
title('Eigenfunction for Mathieu''s equation.') 
xlabel('Solution at mesh points only.')
shg

% Plotting the solution just at the mesh points does not result in a 
% smooth graph near the ends of the interval.  The approximate solution 
% S(x) is continuous and has a continuous derivative.  BVPVAL is used to
% evaluate it at enough points to get a smooth graph.
figure
xint = linspace(0,pi);
Sxint = bvpval(sol,xint);
plot(xint,Sxint(1,:))
axis([0 pi -1 1])
title('Eigenfunction for Mathieu''s equation.') 
xlabel('Solution evaluated on a finer mesh with BVPVAL.')
shg

% --------------------------------------------------------------------------

function dydx = ex3ode(x,y,lambda)
q = 5;
dydx = [              y(2)
         -(lambda - 2*q*cos(2*x))*y(1) ];

% --------------------------------------------------------------------------
  
function res = ex3bc(ya,yb,lambda)
res = [ya(2) 
       yb(2) 
       ya(1) - 1];
  
% --------------------------------------------------------------------------
  
function v = ex3init(x)
v = [   cos(4*x)
      -4*sin(4*x) ];
