function ydot = lorenzeq(t,y)
%LORENZEQ Equation of the Lorenz chaotic attractor.
%   ydot = lorenzeq(t,y).
%   The differential equation is written in almost linear form.

SIGMA = 10.;
RHO = 28.;
BETA = 8./3.;


A = [ -BETA    0     y(2)
    0  -SIGMA   SIGMA
    -y(2)   RHO    -1  ];

ydot = A*y;


