%% 

%{

A bestiary of shapes

This section is something that I hope will grow over time. Its a list of as
many different model forms that I could think of, aggregated into groups with
similar shape. I've provided many different variations of some basic shapes,
so there are multiple, subtle variations of an S shaped curve. I'll include
any pertinent facts about the form, along with matlab functions one can use to
build up models with these simple functional atoms.

The functional atomic forms in this bestiary are suitable for use in my
regression tools pleas.m and fminspleas.m. You can find pleas here:

http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=8553&objectType=FILE

And fminspleas here:

http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=10093&objectType=FILE

I've generally tried to avoid functional forms with singularities or restricted
domains in this bestiary. These cause problems in estimation, especially if
you have a translation parameter. Some examples of functions I've avoided listing
here are tan, sqrt, log, gamma and asin. This does not mean those functions
cannot be used, but you should use them with care. Generally constraints are
necessary for these forms to avoid the singularities.

Some of the forms below are piecewise functions. There are many ways to
implement a piecewise function, but a simple one is to use my piecewise_eval
from the file exchange. Find it here:

http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=9394&objectType=FILE

Don't forget that piecewise functions will often have singularities of some
order at the break points. I'd recommend use of pieces which are as smooth as
possible at those breaks. For example, the piecewise atan/linear function I've
provided is a C2 function - twice continuously differentiable at the break
point.

Author: John D'Errico
E-mail address: woodchips@rochester.rr.com
Release: 1
Release date: 4/24/06

%}

%%
% ----------------------------------------------------

% Constant function
f = @(x) x.^0;
close
fplot(f,[-5,5])
title 'Constant'
% Limiting behavior & specific values
%  f(-inf) = 1
%  f(inf) = 1
%
% Singularities
%  None

%%
% ----------------------------------------------------

% Step function, unit Heaviside function
f = @(x) double(x>=0);
fplot(f,[-5,5,-1,2])
title 'Step'
% Limiting behavior & specific values
%  f(-inf) = 0
%  f(inf) = 1
%
% Singularities
%  x == 0 (discontinuity)

%%
% ----------------------------------------------------

% Linear monomial term
f = @(x) x;
fplot(f,[-5,5])
title 'Linear monomial'
grid on
% Limiting behavior & specific values
%  f(-inf) = -inf
%  f(0) = 0
%  f(inf) = inf
%
% Singularities
%  None

%%
% ----------------------------------------------------

% Absolute value
f = @(x) abs(x);
fplot(f,[-5,5])
title 'Abs'
grid on
% Limiting behavior & specific values
%  f(-inf) = inf
%  f(0) = 0
%  f(inf) = inf
%
% Singularities
%  x == 0 (derivative discontinuity)

%%
% ----------------------------------------------------

% Linear plus function
f = @(x) x.*(x>=0);
fplot(f,[-5,5])
title 'x+'
grid on
% Limiting behavior & specific values
%  f(-inf) = 0
%  f(0) = 0
%  f(inf) = inf
%
% Singularities
%  x == 0 (derivative discontinuity)
%
% Note: this could have been written as
%  f = @(x) x + abs(x);

%%
% ----------------------------------------------------

% Odd order monomial term
f3 = @(x) x.^3;
fplot(f3,[-1.5,1.5],'r-')
hold on
f5 = @(x) x.^5;
fplot(f5,[-1.5,1.5],'g-')
f7 = @(x) x.^7;
fplot(f7,[-1.5,1.5],'b-')
hold off
grid on
legend('x^3','x^5','x^7','location','NorthWest')
title 'Odd order monomial'
% Limiting behavior & specific values
%  f(-inf) = -inf
%  f(0) = 0
%  f(inf) = inf
%
% Singularities
%  None

%%
% ----------------------------------------------------

% Even order monomial term
f2 = @(x) x.^2;
fplot(f2,[-1.5,1.5],'r-')
hold on
f4 = @(x) x.^4;
fplot(f4,[-1.5,1.5],'g-')
f6 = @(x) x.^6;
fplot(f6,[-1.5,1.5],'b-')
hold off
grid on
legend('x^2','x^4','x^6','location','NorthWest')
title 'Even order monomial'
% Limiting behavior & specific values
%  f(-inf) = inf
%  f(0) = 0
%  f(inf) = inf
%
% Singularities
%  None

%%
% ----------------------------------------------------

% Gaussian bell curve (unit half width @ half height)
f = @(x) exp(-log(2)*x.^2);
fplot(f,[-5,5])
grid on
title 'Gaussian'
% Limiting behavior & specific values
%  f(-inf) = 0
%  f(0) = 1
%  f(inf) = 0
%
% Singularities
%  None
%
% Note: int(f(x)*dx,-inf,inf) == sqrt(pi/log(2))
% Note: Half height occurs at the points
%   x = {-1, 1}

%%
% ----------------------------------------------------

% Inverse quadric bell
f = @(x) 1./(1+x.^2);
fplot(f,[-5,5])
title 'Inverse quadric bell'
grid on
% Limiting behavior & specific values
%  f(-inf) = 0
%  f(0) = 1
%  f(inf) = 0
%
% Singularities
%  None
%
% Note: int(f(x)*dx,-inf,inf) == pi
% Note: Half height occurs at the points
%   x = {-1, 1}

%%
% ----------------------------------------------------

% Logistic bell (derived from the logistic curve)
f = @(x) 4*exp(log(3-sqrt(8))*x)./(1+exp(log(3-sqrt(8))*x)).^2;
% f = @(x) 4*exp(-x)./(1+exp(-x)).^2;
fplot(f,[-5,5])
title 'Logistic bell'
grid on
% Limiting behavior & specific values
%  f(-inf) = 0
%  f(0) = 1
%  f(inf) = 0
%
% Singularities
%  None
%
% Note: int(f(x)*dx,-inf,inf) == -4/log(3-sqrt(8))
% Note: Half height occurs at the points
%   x = {-1, 1}

%%
% ----------------------------------------------------

% Sech^2 bell (derived from the tanh function)
f = @(x) sech(x*asech(sqrt(1/2))).^2;
fplot(f,[-5,5])
title 'Sech^2 bell'
grid on
% Limiting behavior & specific values
%  f(-inf) = 0
%  f(0) = 1
%  f(inf) = 0
%
% Singularities
%  None
%
% Note: int(f(x)*dx,-inf,inf) == 2/asech(sqrt(1/2))
% Note: Half height occurs at the points
%   x = {-1, 1}

%%
% ----------------------------------------------------

% Gaussian bell derivative
f = @(x) -2*log(2)*x.*exp(-log(2)*x.^2);
fplot(f,[-5,5])
grid on
title 'Gaussian derivative'
% Limiting behavior & specific values
%  f(-inf) = 0
%  f(0) = 1
%  f(inf) = 0
%
% Singularities
%  None

%%
% ----------------------------------------------------

% Inverse quadric bell derivative
f = @(x) 2*x.*(1+x.^2).^(-3/2);
fplot(f,[-5,5])
title 'Inverse quadric bell derivative'
grid on
% Limiting behavior & specific values
%  f(-inf) = 0
%  f(0) = 0
%  f(inf) = 0
%
% Singularities
%  None

%%
% ----------------------------------------------------

% Logistic curve
f = @(x) 1./(1+exp(-x));
fplot(f,[-5,5])
title 'Logistic'
grid on
% Limiting behavior & specific values
%  f(-inf) = 0
%  f(0) = 1/2
%  f(inf) = 1
%
% Singularities
%  None
%
% Note: f'(0) == 1/4

%%
% ----------------------------------------------------

% Erf
f = @(x) erf(x);
fplot(f,[-5,5])
title 'Erf'
grid on
% Limiting behavior & specific values
%  f(-inf) = -1
%  f(0) = 0
%  f(inf) = 1
%
% Singularities
%  None
%
% Note: f'(0) == 2/sqrt(pi)

%%
% ----------------------------------------------------

% Complementary error function, erfc(x) - 1-erf(x)
f = @(x) erfc(x);
fplot(f,[-5,5])
title 'Erfc'
grid on
% Limiting behavior & specific values
%  f(-inf) = 2
%  f(0) = 1
%  f(inf) = 0
%
% Singularities
%  None
%
% Note: f'(0) == -2/sqrt(pi)

%%
% ----------------------------------------------------

% Inverse (arc) tangent
f = @(x) atan(x);
fplot(f,[-5,5])
title 'atan'
grid on
% Limiting behavior & specific values
%  f(-inf) = -pi/2
%  f(0) = 0
%  f(inf) = pi/2
%
% Singularities
%  None
%
% Note: f'(0) = 1

%%
% ----------------------------------------------------

% Paired hyperbolas to form an S curve
f = @(x) (sqrt(1+(x+1).^2) - sqrt(1+(x-1).^2))/2;
fplot(f,[-10,10])
grid on
title 'Paired Hyperbolas'
% Limiting behavior & specific values
%  f(-inf) = -1
%  f(0) = 0
%  f(inf) = 1
%
% Singularities
%  None
%
% Note: f'(0) == 1/sqrt(2)

%%
% ----------------------------------------------------

% Hyperbolic tan
f = @(x) tanh(x);
fplot(f,[-5,5])
title 'Tanh'
grid on
% Limiting behavior & specific values
%  f(-inf) = -1
%  f(0) = 0
%  f(inf) = 1
%
% Singularities
%  None
%
% Note: f'(0) = 1

%%
% ----------------------------------------------------

% Exponential rise
f = @(x) exp(x);
fplot(f,[-5,5])
title 'Exp(x)'
grid on
% Limiting behavior & specific values
%  f(-inf) = 0
%  f(0) = 1
%  f(inf) = inf
%
% Singularities
%  None
%
% Note: f'(0) = 1

%%
% ----------------------------------------------------

% Exponential decay
f = @(x) exp(-x);
fplot(f,[-5,5])
title 'Exp(-x)'
grid on
% Limiting behavior & specific values
%  f(-inf) = inf
%  f(0) = 1
%  f(inf) = 0
%
% Singularities
%  None
%
% Note: f'(0) = -1

%%
% ----------------------------------------------------

% Hyperbolic sine, sinh(x) = (exp(x) - exp(-x))/2
f = @(x) sinh(x);
fplot(f,[-5,5])
title 'sinh'
grid on
% Limiting behavior & specific values
%  f(-inf) = -inf
%  f(0) = 0
%  f(inf) = inf
%
% Singularities
%  None
%
% Note: f'(0) = 1

%%
% ----------------------------------------------------

% Hyperbolic cosine, cosh(x) = (exp(x) + exp(-x))/2
f = @(x) cosh(x);
fplot(f,[-5,5])
title 'cosh'
grid on
% Limiting behavior & specific values
%  f(-inf) = inf
%  f(0) = 0
%  f(inf) = inf
%
% Singularities
%  None
%
% Note: f'(0) = 0

%%
% ----------------------------------------------------

% Erf integral
f = @(x) x.*erf(x) + exp(-x.^2)/sqrt(pi);
fplot(f,[-5,5])
title 'Erf integral'
grid on
% Limiting behavior & specific values
%  f(-inf) = inf
%  f(0) = 1/sqrt(pi)
%  f(inf) = inf
%
% Singularities
%  None
%
% Note: f'(0) = 0

%%
% ----------------------------------------------------

% Hyperbola
f = @(x) sqrt(1+x.^2);
fplot(f,[-5,5])
title 'Hyperbola'
grid on
% Limiting behavior & specific values
%  f(-inf) = inf
%  f(0) = 1
%  f(inf) = inf
%
% Singularities
%  None
%
% Note: f'(0) = 0

%%
% ----------------------------------------------------

% Piecewise atan rise from 0 to 1/2, to a linear rise above x = 0
f = @(x) (x/pi+0.5).*(x>=0) + (atan(x)/pi+0.5).*(x<0);
fplot(f,[-10,10])
grid on
title 'Piecewise function'
% Limiting behavior & specific values
%  f(-inf) = 0
%  f(0) = 1/2
%  f(inf) = inf
%
% Singularities
%  x == 0 (third derivative discontinuity)
%
% Note: f'(x>0) = 1/pi

%%
% ----------------------------------------------------

% Hyperbolic rise from 0 to an asymptote to y = x
f = @(x) (x + sqrt(1+x.^2))/2;
fplot(f,[-10,10])
grid on
title 'Hyperbolic rise'
% Limiting behavior & specific values
%  f(-inf) = 0
%  f(0) = 1/2
%  f(inf) = inf
%
% Singularities
%  None

%%
% ----------------------------------------------------

% Sine
f = @(x) sin(x);
fplot(f,[-2*pi,2*pi])
title 'Sin(X)'
grid on
% Limiting behavior & specific values
%  f(0) = 0
%
% Singularities
%  None
%
% Note: Period = 2*pi

%%
% ----------------------------------------------------

% Cosine, cos(x) = sin(x+pi/2)
f = @(x) cos(x);
fplot(f,[-2*pi,2*pi])
title 'Cos(x)'
grid on
% Limiting behavior & specific values
%  f(0) = 1
%
% Singularities
%  None
%
% Note: Period = 2*pi

%%

