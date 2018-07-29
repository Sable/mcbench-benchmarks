% DERIVEST demo script

% This script file is designed to be used in cell mode
% from the matlab editor, or best of all, use the publish
% to HTML feature from the matlab editor. Older versions
% of matlab can copy and paste entire blocks of code into
% the Matlab command window.

% DERIVEST is property/value is driven for its arguments.
% Properties can be shortened to the

%% derivative of exp(x), at x == 0
[deriv,err] = derivest(@(x) exp(x),0)

%% DERIVEST can also use an inline function
[deriv,err] = derivest(inline('exp(x)'),0)

%% Higher order derivatives (second derivative)
% Truth: 0
[deriv,err] = derivest(@(x) sin(x),pi,'deriv',2)

%% Higher order derivatives (third derivative)
% Truth: 1
[deriv,err] = derivest(@(x) cos(x),pi/2,'der',3)

%% Higher order derivatives (up to the fourth derivative)
% Truth: sqrt(2)/2 = 0.707106781186548
[deriv,err] = derivest(@(x) sin(x),pi/4,'d',4)

%% Evaluate the indicated (default = first) derivative at multiple points
[deriv,err] = derivest(@(x) sin(x),linspace(0,2*pi,13))

%% Specify the step size (default stepsize = 0.1)
deriv = derivest(@(x) polyval(1:5,x),1,'deriv',4,'FixedStep',1)

%% Provide other parameters via an anonymous function
% At a minimizer of a function, its derivative should be
% essentially zero. So, first, find a local minima of a
% first kind bessel function of order nu.
nu = 0;
fun = @(t) besselj(nu,t);
fplot(fun,[0,10])
x0 = fminbnd(fun,0,10,optimset('TolX',1.e-15))
hold on
plot(x0,fun(x0),'ro')
hold off

deriv = derivest(fun,x0,'d',1)

%% The second derivative should be positive at a minimizer.
deriv = derivest(fun,x0,'d',2)

%% Compute the numerical gradient vector of a 2-d function
% Note: the gradient at this point should be [4 6]
fun = @(x,y) x.^2 + y.^2;
xy = [2 3];
gradvec = [derivest(@(x) fun(x,xy(2)),xy(1),'d',1), ...
           derivest(@(y) fun(xy(1),y),xy(2),'d',1)]

%% Compute the numerical Laplacian function of a 2-d function
% Note: The Laplacian of this function should be everywhere == 4
fun = @(x,y) x.^2 + y.^2;
xy = [2 3];
lapval = derivest(@(x) fun(x,xy(2)),xy(1),'d',2) + ...
           derivest(@(y) fun(xy(1),y),xy(2),'d',2)

%% Compute the derivative of a function using a central difference scheme
% Sometimes you may not want your function to be evaluated
% above or below a given point. A 'central' difference scheme will
% look in both directions equally.
[deriv,err] = derivest(@(x) sinh(x),0,'Style','central')

%% Compute the derivative of a function using a forward difference scheme
% But a forward scheme will only look above x0.
[deriv,err] = derivest(@(x) sinh(x),0,'Style','forward')

%% Compute the derivative of a function using a backward difference scheme
% And a backward scheme will only look below x0.
[deriv,err] = derivest(@(x) sinh(x),0,'Style','backward')

%% Although a central rule may put some samples in the wrong places, it may still succeed
[d,e,del]=derivest(@(x) log(x),.001,'style','central')

%% But forcing the use of a one-sided rule may be smart anyway
[d,e,del]=derivest(@(x) log(x),.001,'style','forward')

%% Control the behavior of DERIVEST - forward 2nd order method, with only 1 Romberg term
% Compute the first derivative, also return the final stepsize chosen
[deriv,err,fdelta] = derivest(@(x) tan(x),pi,'deriv',1,'Style','for','MethodOrder',2,'RombergTerms',1)

%% Functions should be vectorized for speed, but its not always easy to do.
[deriv,err] = derivest(@(x) x.^2,0:5,'deriv',1)
[deriv,err] = derivest(@(x) x^2,0:5,'deriv',1,'vectorized','no')


