function ex7bvp
%EX7BVP  Example 7 of the BVP tutorial.
%   This is the first example problem for D02HBF from the NAG library.  
%   The problem is y'' = (y^3 - y')/(2x), y(0) = 0.1, y(16) = 1/6.  The
%   singularity at the origin is handled by using a series to represent 
%   the solution and its derivative at a "small" distance d > 0, namely
%   
%      y(d)  = 0.1 + y'(0)*sqrt(d)/10 + d/100 
%      y'(d) = y'(0)/(20*sqrt(d)) + 1/100
%   
%   The value y'(0) is treated as an unknown parameter p. The problem is
%   solved numerically on [d, 16].  Two boundary conditions are that the
%   computed solution and its first derivative agree with the values from
%   the series at d.  The remaining boundary condition is y(16) = 1/6.
%   
%   The results from the documentation for D02HBF are here compared to 
%   curves produced by bvp4c.

% Copyright 1999, The MathWorks, Inc.

options = bvpset('stats','on');

d = 0.1;  % The known parameter
solinit = bvpinit(linspace(d,16,5),[1 1],0.2);

sol = bvp4c(@ex7ode,@ex7bc,solinit,options,d);

% Augment the solution array with the values y(0) = 0.1, y'(0) = p
% to get a solution on [0, 16].
x = [0 sol.x];
y = [[0.1; sol.parameters] sol.y];

% Solution obtained using D02HBF, augmented with the values y(0), y'(0).
nagx = [0.00 0.10 3.28 6.46 9.64 12.82 16.00]';
nagy = [0.1000  4.629e-2
        0.1025  0.0173
        0.1217  0.0042
        0.1338  0.0036
        0.1449  0.0034
        0.1557  0.0034
        0.1667  0.0035];

clf reset
plot(x,y(1,:),x,y(2,:),'--',nagx,nagy,'*')
axis([-1 16 0 0.18])
title('Problem with singular behavior at the origin.')
xlabel('x')
ylabel('y, dy/dx (--), and D02HBF (*) solutions')
shg

% --------------------------------------------------------------------------

function dydx = ex7ode(x,y,p,d)
%EX7ODE  ODE function for Example 7 of the BVP tutorial.
dydx = [ y(2)
        (y(1)^3 - y(2))/(2*x) ];

% --------------------------------------------------------------------------

function res = ex7bc(ya,yb,p,d)
%EX7BC  Boundary conditions for Example 7 of the BVP tutorial.
%   The boundary conditions at x = d are that y and y' have
%   values yatd and ypatd obtained from series expansions.
%   The unknown parameter p = y'(0) and known parameter d are 
%   used in the expansions.
yatd =  0.1 + p*sqrt(d)/10 + d/100;
ypatd = p/(20*sqrt(d)) + 1/100;
res = [ ya(1) - yatd
        ya(2) - ypatd
        yb(1) - 1/6 ];

