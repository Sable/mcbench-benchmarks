function [xroot, froot] = brent (f, x1, x2, rtol)

% solve for a single real root of a nonlinear equation

% Brent's method

% input

%  f    = objective function coded as y = f(x)
%  x1   = lower bound of search interval
%  x2   = upper bound of search interval
%  rtol = algorithm convergence criterion

% output

%  xroot  = real root of f(x) = 0
%  froot  = function value at f(x) = 0

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global iter;

% machine epsilon

eps = 2.23e-16;

e = 0;

a = x1;
b = x2;

fa = feval(f, a);

fb = feval(f, b);

fc = fb;

for iter = 1:1:50 
        
    if (fb * fc > 0)
       c = a;
       fc = fa;
       d = b - a;
       e = d;
    end

    if (abs(fc) < abs(fb))
       a = b;
       b = c;
       c = a;
       fa = fb;
       fb = fc;
       fc = fa;
    end

    tol1 = 2 * eps * abs(b) + 0.5 * rtol;

    xm = 0.5 * (c - b);

    if (abs(xm) <= tol1 || fb == 0)
       break;
    end

    if (abs(e) >= tol1 && abs(fa) > abs(fb))
       s = fb / fa;
       
       if (a == c)
          p = 2 * xm * s;
          q = 1 - s;
       else
          q = fa / fc;
          r = fb / fc;
          p = s * (2 * xm * q * (q - r) - (b - a) * (r - 1));
          q = (q - 1) * (r - 1) * (s - 1);
       end

       if (p > 0)
          q = -q;
       end

       p = abs(p);

       min = abs(e * q);
       
       tmp = 3 * xm * q - abs(tol1 * q);
           
       if (min < tmp)
          min = tmp;
       end

       if (2 * p < min)
          e = d;
          d = p / q;
       else
          d = xm;
          e = d;
       end
    else
       d = xm;
       e = d;
    end

    a = b;
    fa = fb;

    if (abs(d) > tol1)
       b = b + d;
    else
       b = b + sign(xm) * tol1;
    end

    fb = feval(f, b);

end

xroot = b;
froot = fb;
