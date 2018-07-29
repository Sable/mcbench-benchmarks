function [xmin, fmin] = minima (f, a, b, tolm)

% one-dimensional minimization

% Brent's method

% input

%  f    = objective function coded as y = f(x)
%  a    = initial x search value
%  b    = final x search value
%  tolm = convergence criterion

% output

%  xmin = minimum x value
%  fmin = minimum function value

% Celestial Computing with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% machine epsilon

epsm = 2.23e-16;

% golden number

c = 0.38196601125;

x = a + c * (b - a);

w = x;
v = w;

e = 0;
p = 0;
q = 0;
r = 0;

fx = feval(f, x);

fw = fx;
fv = fw;

niter = 0;

while (1)
  niter = niter + 1;

  if (niter > 50)
     clc; home;
     fprintf('\n\n  error in function minima !!!');
     fprintf('\n     (more than 50 iterations)');
     keycheck;
     return;
  end

  xm = 0.5 * (a + b);
  tol1 = tolm * abs(x) + epsm;
  t2 = 2 * tol1;

  if (abs(x - xm) <= (t2 - 0.5 * (b - a)))
     xmin = x;
     fmin = fx;
     return;
  else
     if (abs(e) > tol1)
        r = (x - w) * (fx - fv);
        q = (x - v) * (fx - fw);
        p = (x - v) * q - (x - w) * r;
        q = 2 * (q - r);

        if (q > 0) 
           p = -p;
        end

        q = abs(q);
        r = e;
        e = d;
     end

     if ((abs(p) >= abs(.5 * q * r)) | (p <= q * (a - x)) | (p >= q * (b - x)))
        if (x >= xm)
           e = a - x;
        else
           e = b - x;
        end

        d = c * e;
     else
        d = p / q;
        u = x + d;
        if ((u - a) < t2) | ((b - u) < t2) 
           d = sign(xm - x) * tol1;
        end
     end

     if (abs(d) >= tol1)
        u = x + d;
     else
        u = x + sign(d) * tol1;
     end

     fu = feval(f, u);

     if (fu <= fx)
        if (u >= x)
           a = x;
        else
           b = x;
        end
        v = w;
        fv = fw;
        w = x;
        fw = fx;
        x = u;
        fx = fu;
     else
        if (u < x)
           a = u;
        else
           b = u;
        end
        if ((fu <= fw) | (w == x))
           v = w;
           fv = fw;
           w = u;
           fw = fu;
        elseif ((fu <= fv) | (v == x) | (v == w))
           v = u;
           fv = fu;
        end
     end
  end
end

