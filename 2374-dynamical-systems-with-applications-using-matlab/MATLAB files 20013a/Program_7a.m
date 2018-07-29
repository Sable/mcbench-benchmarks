% Chapter 7 - Differential Equations.
% Program_7a - Solving Simple Differential Equations.
% Symbolic Math toolbox required.
% Copyright Birkhauser 2013. Stephen Lynch.

% A separable ODE (Example 1).
soln1=dsolve('Dx=-t/x')

% Chemical kinetics (Example 8).
a=4;b=1;k=.00713;
soln2=dsolve('Dc=k*(a-c)^2*(b-c/2)')

% A 3-D system (Exercise 7).
w=dsolve('Dx=-a*x','Dy=a*x-b*y','Dz=b*y');
xsol=w.x
ysol=w.y
zsol=w.z

% End of Program_7a.