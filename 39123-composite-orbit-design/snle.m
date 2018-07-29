function [x, niter, icheck] = snle (usrfun, x, n, maxiter)

% solution of a system of non-linear equations function

% input

%  usrfun  = name of user-defined function that evaluates nle system
%  x       = initial guess for solution vector
%  n       = number of elements in solution vector
%  maxiter = maximum number of algorithm iterations allowed

% output

%  x      = solution vector
%  niter  = number of algorithm iterations performed
%  icheck = solution indicator
%         = 0 ==> normal return
%         = 1 ==> algorithm can make no further progress

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global fvec

eps = 1.0d-7;

% convergence criteria

tolf = 1.0d-4;

tolmin = 1.0d-6;

tolx = eps;

stpmx = 100.0d0;

f = bfmin(usrfun, n, x);

test = 0.0d0;

for i = 1:1:n
    if (abs(fvec(i)) > test)
       test = abs(fvec(i));
    end
end

if (test < 0.01d0 * tolf)
   return;
end

sum = 0.0d0;

for i = 1:1:n
    sum = sum + x(i) * x(i);
end

stpmax = stpmx * max(sqrt(sum), double(n));

irestrt = 1;

for niter = 1:1:maxiter

    if (irestrt == 1) 

       r = fdjac(usrfun, n, x, fvec);

       [r, c, d, ising] = qrdcmp (r, n);
         
       if (ising == 1)
          clc; home;
          fprintf('\n\n   singular jacobian!! \n\n'); 
          keycheck;
       end
          
       for i = 1:1:n
           for j = 1:1:n
               qt(i, j) = 0.0d0;
           end

           qt(i, i) = 1.0d0;
       end

       for k = 1:1:n - 1
           if (c(k) ~= 0.0d0) 

              for j = 1:1:n
                  sum = 0.0d0;

                  for i = k:1:n
                      sum = sum + r(i, k) * qt(i, j);
                  end

                  sum = sum / c(k);

                  for i = k:1:n
                      qt(i, j) = qt(i, j) - sum * r(i, k);
                  end
               end
           end
       end

       for i = 1:1:n
           r(i, i) = d(i);

           for j = 1:1:i - 1
               r(i, j) = 0.0d0;
           end
       end

    else
       for i = 1:1:n
           s(i) = x(i) - xold(i);
       end

       for i = 1:1:n
           sum = 0.0d0;

           for j = i:1:n
               sum = sum + r(i, j) * s(j);
           end

           t(i) = sum;
       end

       iskip = 1;

       for i = 1:1:n
           sum = 0.0d0;

           for j = 1:1:n
               sum = sum + qt(j, i) * t(j);
           end

           w(i) = fvec(i) - fvcold(i) - sum;

           if (abs(w(i)) >= eps * (abs(fvec(i)) + abs(fvcold(i)))) 
              iskip = 0;
           else
              w(i) = 0.0d0;
           end
       end

       if (iskip == 0) 

          for i = 1:1:n
              sum = 0.0d0;

              for j = 1:1:n
                  sum = sum + qt(i, j) * w(j);
              end

              t(i) = sum;
          end

          den = 0.0d0;

          for i = 1:1:n
              den = den + s(i) * s(i);
          end

          for i = 1:1:n
              s(i) = s(i) / den;
          end

          [qt, r] = qrupdt(r, qt, n, t, s);

          for i = 1:1:n
              if (r(i, i) == 0.0d0)
                 clc; home;
                 fprintf('\n\n   r matrix singular!! \n\n'); 
                 keycheck;
              end

              d(i) = r(i, i);
          end
       end
    end

    for i = 1:1:n

        sum = 0.0d0;

        for j = 1:1:n
            sum = sum + qt(i, j) * fvec(j);
        end

        g(i) = sum;
    end

    for i = n:-1:1
        sum = 0.0d0;

        for j = 1:1:i
            sum = sum + r(j, i) * g(j);
        end

        g(i) = sum;
    end

    for i = 1:1:n
        xold(i) = x(i);

        fvcold(i) = fvec(i);
    end

    fold = f;

    for i = 1:1:n
        sum = 0.0d0;

        for j = 1:1:n
            sum = sum + qt(i, j) * fvec(j);
        end

        p(i) = -sum;
    end

    p = rsolv(r, n, d, p);

    [x, f, icheck] = lnsrch (n, usrfun, xold, fold, g, p, stpmax);

    test = 0.0d0;

    for i = 1:1:n
        if (abs(fvec(i)) > test)
           test = abs(fvec(i));
        end
    end

    if (test < tolf) 
       icheck = 0;
       return
    end

    if (icheck == 1) 
       if (irestrt == 1) 
          return
       else
          test = 0.0d0;

          den = max(f, 0.5d0 * double(n));
   
          for i = 1:1:n
              temp = abs(g(i)) * max(abs(x(i)), 1.0d0) / den;

              if (temp > test)
                 test = temp;
              end
          end

          if (test < tolmin) 
             return
          else
             irestrt = 1;
          end
       end
    else
       irestrt = 0;

       test = 0.0d0;

       for i = 1:1:n
           temp = (abs(x(i) - xold(i))) / max(abs(x(i)), 1.0d0);

           if (temp > test)
              test = temp;
           end
       end

       if (test < tolx)
          return;
       end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fm = bfmin (usrfun, n, x)

% broyden support function

global fvec;

fvec = feval(usrfun, x);

sum = 0.0d0;

for i = 1:1:n
    sum = sum + fvec(i) * fvec(i);
end

fm = 0.5d0 * sum;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x, f, icheck] = lnsrch (n, usrfun, xold, fold, g, p, stpmax)

% line search function

global fvec

alf = 0.0001d0;

tolx = 0.0000001d0;

icheck = 0;

sum = 0.0d0;

for i = 1:1:n
    sum = sum + p(i) * p(i);
end

sum = sqrt(sum);

if (sum > stpmax) 
   for i = 1:1:n
       p(i) = p(i) * stpmax / sum;
   end
end

slope = 0.0d0;

for i = 1:1:n
    slope = slope + g(i) * p(i);
end

test = 0.0d0;

for i = 1:1:n
    temp = abs(p(i)) / max(abs(xold(i)), 1.0d0);

    if (temp > test)
       test = temp;
    end

end

alamin = tolx / test;

alam = 1.0d0;

while (1 == 1)
   for i = 1:1:n
       x(i) = xold(i) + alam * p(i);
   end

   f = bfmin(usrfun, n, x);

   if (alam < alamin) 

      for i = 1:1:n
          x(i) = xold(i);
      end

      icheck = 1;

      return;
   elseif (f <= (fold + alf * alam * slope)) 
      return;
   else
      if (alam == 1.0d0) 
         tmplam = -slope / (2.0d0 * (f - fold - slope));
      else
         rhs1 = f - fold - alam * slope;

         rhs2 = f2 - fold2 - alam2 * slope;

         a = (rhs1 / alam ^ 2 - rhs2 / alam2 ^ 2) / (alam - alam2);

         b = (-alam2 * rhs1 / alam ^ 2 + alam * rhs2 / alam2 ^ 2) / (alam - alam2);

         if (a == 0.0d0) 
            tmplam = -slope / (2.0d0 * b);
         else
            disc = b * b - 3.0d0 * a * slope;
            tmplam = (-b + sqrt(disc)) / (3.0d0 * a);
         end

         if (tmplam > 0.5d0 * alam)
            tmplam = 0.5d0 * alam;
         end
      end
   end

   alam2 = alam;

   f2 = f;

   fold2 = fold;

   alam = max(tmplam, 0.1d0 * alam);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [qt, r] = qrupdt (r, qt, n, u, v)

% QR decomposition update function

ibreak = 0;

for k = n:-1:1
    if (u(k) ~= 0.0d0)
       ibreak = 1;
       break;
    end
end

if (ibreak == 0)
   k = 1;
end

for i = k - 1:-1:1
    
    [qt, r] = rotate(r, qt, n, i, u(i), -u(i + 1));

    if (u(i) == 0.0d0) 

       u(i) = abs(u(i + 1));

    elseif (abs(u(i)) > abs(u(i + 1))) 

       u(i) = abs(u(i)) * sqrt(1.0d0 + (u(i + 1) / u(i)) ^ 2);

    else

       u(i) = abs(u(i + 1)) * sqrt(1.0d0 + (u(i) / u(i + 1)) ^ 2);

    end
end

for j = 1:1:n
    r(1, j) = r(1, j) + u(1) * v(j);
end

for i = 1:1:k - 1
    [qt, r] = rotate(r, qt, n, i, r(i, i), -r(i + 1, i));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [a, c, d, ising] = qrdcmp (a, n)

% QR decomposition function

ising = 0;

scale = 0.0d0;

for k = 1:1:n - 1

    for i = k:1:n

        scale = max(scale, abs(a(i, k)));
    end

    if (scale == 0.0d0) 
       ising = 1;

       c(k) = 0.0d0;

       d(k) = 0.0d0;
    else
       for i = k:1:n
           a(i, k) = a(i, k) / scale;
       end

       sum = 0.0d0;

       for i = k:1:n
           sum = sum + a(i, k) * a(i, k);
       end

       sigma = sign(a(k, k)) * sqrt(sum);

       a(k, k) = a(k, k) + sigma;

       c(k) = sigma * a(k, k);

       d(k) = -scale * sigma;

       for j = k + 1:1:n
           sum = 0.0d0;

           for i = k:1:n
               sum = sum + a(i, k) * a(i, j);
           end

           tau = sum / c(k);

           for i = k:1:n
               a(i, j) = a(i, j) - tau * a(i, k);
           end
       end
    end
end

d(n) = a(n, n);

if (d(n) == 0.0d0)
   ising = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [qt, r] = rotate (r, qt, n, i, a, b)

% Jacobi rotation function

if (a == 0.0d0) 
   c = 0.0d0;

   s = sign(b) * 1.0d0;

elseif (abs(a) > abs(b)) 
   fact = b / a;

   c = sign(a) * (1.0d0 / sqrt(1.0d0 + fact ^ 2));

   s = fact * c;

else
   fact = a / b;

   s = sign(b) * (1.0d0 / sqrt(1.0d0 + fact ^ 2));

   c = fact * s;
end

for j = i:1:n
    y = r(i, j);

    w = r(i + 1, j);

    r(i, j) = c * y - s * w;

    r(i + 1, j) = s * y + c * w;
end

for j = 1:1:n
    y = qt(i, j);

    w = qt(i + 1, j);

    qt(i, j) = c * y - s * w;

    qt(i + 1, j) = s * y + c * w;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function xjac = fdjac (usrfun, n, x, fvec)

% forward difference numerical jacobian function

% input

%  usrfun = name of function that evaluates nle system
%  x      = current evaluation vector

% output

%  xjac = numerical jacobian at x

deps = 0.0001d0;

% compute components of jacobian

for j = 1:1:n
    temp = x(j);

    h = deps * abs(temp);

    if (h == 0.0d0)
       h = deps;
    end

    x(j) = temp + h;

    f = feval(usrfun, x);

    x(j) = temp;

    for i = 1:1:n
        xjac(i, j) = (f(i) - fvec(i)) / h;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function b = rsolv (a, n, d, b)

% broyden support function

b(n) = b(n) / d(n);

for i = n - 1:-1:1
    sum = 0.0d0;

    for j = i + 1:1:n
        sum = sum + a(i, j) * b(j);
    end

    b(i) = (b(i) - sum) / d(i);
end








