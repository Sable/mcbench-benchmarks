function  [xx, yy, hdid, hnext, nfev] = bsstep1(y, dy, x, htry, hmax, eps, yscal, odefun, la, kb, kk0)
% bsstep. m  takes a step in the Bulirsch-Stoer method to solve ode's, see 
% W Press ea.in "Numerical Recipes" (1994) p724-732. This is a special purpose version
% which is used in parallel solving a number of problems with different kb values
%
% inputs : the dependent variable vector y(1..nv, 1..np) and its derivative dy(1..nv, 1..np) at the
% starting value of the independent variable x(1..np), also the stepsize htry(1..np) to be attempted,
% the maximum stepsize allowed (hmax),
% the required accuracy (eps), the vector yscal(1..nv, 1..np) against which the error is scaled
% and a client function to calculate the right-hand side derivatives (odefun) together with
% some additional variables la, kb(1..np), kk0 used by odefun (which are specific for the problem).
%
% output : the steps taken, xx(1..nv, 1..np) and the corresponding values of the dependent variable,
%  y(1..nv, 1..np), the actual stepsize that was accomplished hdid(1..np) and the estimated next stepsize 
%  hnext(1..np) and the number of function evaluations (nfev)

% D Vangheluwe 8 mrt 2005, revised 2 may 2005
% remark 1: yseq, yy, yerr, yscal are matrices (1..nv, 1..np)
% remark 2: err is a matrix (kmaxx-1, np) 

% global variables used by the interpolator
global x_bulirsch_stoer  d_bulirsch_stoer

% include constant (see #include)
kmaxx = 8;
imaxx = kmaxx + 1;
safe1 = 0.25;
safe2 = 0.7;
redmax = 1e-5;
redmin = 0.7;
tiny = 1e-30;
scalmx = 0.1;

% constant integers :
first = 1;
epsold = -1;
nseq = [2 : 2 : 18]';  
exitflag = 0;

% intialisation
nfe1 = 0;    %##### added 11 mrt 2005 : counts the number of function evaluations
red = 0;       %####### added 8 mrt 2005
[nv np] = size(y);
a = zeros(1, imaxx+1);
alf = zeros(kmaxx+1, kmaxx+1);
err = zeros(kmaxx-1, np);
if np > 1
  x_bulirsch_stoer = zeros(kmaxx, np);
  d_bulirsch_stoer = zeros(nv, np, kmaxx);
else
  x_bulirsch_stoer = zeros(kmaxx, 1);
  d_bulirsch_stoer = zeros(nv, kmaxx);
end

if (eps ~= epsold)
    xnew = -1.0e29;
    hnext = xnew;
    eps1 = safe1 * eps;
    a(1) = nseq(1) + 1;
    for k = 1:kmaxx,   a(k+1) = a(k) + nseq(k+1);  end
    for iq = 2:kmaxx
       for k = 1:iq-1
          alf(k, iq) = eps1^ (a(k+1) - a(iq+1))/((a(iq+1) - a(1) + 1) *(2*k + 1));
       end
    end
    epsold = eps;
    for kopt = 2:kmaxx-1
       if  (a(kopt+1) > a(kopt) * alf(kopt-1, kopt)),   break; end
    end
    kmax = kopt;
end

%'**'
h = htry;
ysav = y;
%if  any(x ~= xnew  ||  h ~= hnext), first = 1; kopt = kmax; end
reduct = 0;
while (1)

   for k = 1:kmax
% evaluate the sequence of modified midpoint integrations
      xnew = x + h;
      if  (xnew == x),  error('step size underflow in bsstep'); end
      [yseq, nfe] = mmid1(ysav, dy, x, h, nseq(k), odefun, la, kb, kk0);
%yseq
      nfe1 = nfe1 + nfe;
      xest = (h/nseq(k)) .^2;
% perform extrapolation
      [yy, yerr] = pzextr1(k, xest, yseq);
%k
%[yy, yerr]
      if k ~= 1
         errmax = tiny;
         errmax = max(max(errmax, abs(yerr ./ yscal)));
%errmax
% scale error relative to the tolerance
         errmax = errmax/eps;
         km = k - 1;
         err(km,:) = (errmax/safe1) .^ (1/(2* km + 1));
%err
      end
% do not more then 4 steps : this will give enough accuracy (err < 1e-4), put first that the stepsize
% at the start (htry) is taken sufficiently small 
      if (k > 3)
         exitflag = 1;
         break;
      end
   end  % for k
   if  exitflag == 1, break; end
   red = min(red, redmin);
   red = max(red, redmax);
   h = h * red;
   reduct = 1;
if reduct == 1, message('bsstep1 wants to reduce the step'); end

end  %while

xx = xnew;
hdid = h;
first = 0;
wrkmin = 1.0e35 * ones(1, np);
for kk = 1:km
    fact = max(err(kk, :), scalmx);
    work = fact * a(kk+1);
    if  any(work < wrkmin)
        iw = find(work < wrkmin);
        scale(iw) = fact(iw);
        wrkmin(iw) = work(iw);
        kopt = kk + 1;
    end
end

% stop the increase in stepsize : we want more steps
hnext = h;
if  any(h < hmax .* scale)
   ih = find(h < hmax .* scale);
   hnext(ih) = h(ih) ./ scale(ih);
end
nfev = nfe1;

% check for possible order increase, but not if stepsize was just reduced :
% this step has been omitted for the application, as it gives a far too large step size (## 8 mrt 2005)

return
