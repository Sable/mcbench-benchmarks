function [tout,xout] = myode45(FUN,tspan,x0,pair,ode_fcn_format,tol,trace,count)

% Copyright (C) 2001, 2000 Marc Compere
% This file is intended for use with Octave.
% ode45.m is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2, or (at your option)
% any later version.
%
% ode45.m is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details at www.gnu.org/copyleft/gpl.html.
%
% --------------------------------------------------------------------
%
% ode45 (v1.11) integrates a system of ordinary differential equations using
% 4th & 5th order embedded formulas from Dormand & Prince or Fehlberg.
%
% The Fehlberg 4(5) pair is established and works well, however, the
% Dormand-Prince 4(5) pair minimizes the local truncation error in the
% 5th-order estimate which is what is used to step forward (local extrapolation.)
% Generally it produces more accurate results and costs roughly the same
% computationally.  The Dormand-Prince pair is the default.
%
% This is a 4th-order accurate integrator therefore the local error normally
% expected would be O(h^5).  However, because this particular implementation
% uses the 5th-order estimate for xout (i.e. local extrapolation) moving
% forward with the 5th-order estimate should yield errors on the order of O(h^6).
%
% The order of the RK method is the order of the local *truncation* error, d.
% The local truncation error is defined as the principle error term in the
% portion of the Taylor series expansion that gets dropped.  This portion of
% the Taylor series exapansion is within the group of terms that gets multipled
% by h in the solution definition of the general RK method.  Therefore, the
% order-p solution created by the RK method will be roughly accurate to
% within O(h^(p+1)).  The difference between two different-order solutions is
% the definition of the "local error," l.  This makes the local error, l, as
% large as the error in the lower order method, which is the truncation
% error, d, times h, resulting in O(h^(p+1)).
% Summary:   For an RK method of order-p,
%            - the local truncation error is O(h^p)
%            - the local error (used for stepsize adjustment) is O(h^(p+1))
%
% This requires 6 function evaluations per integration step.
%
% Both the Dormand-Prince and Fehlberg 4(5) coefficients are from a tableu in
% U.M. Ascher, L.R. Petzold, Computer Methods for  Ordinary Differential Equations
% and Differential-Agebraic Equations, Society for Industrial and Applied Mathematics
% (SIAM), Philadelphia, 1998
%
% The error estimate formula and slopes are from
% Numerical Methods for Engineers, 2nd Ed., Chappra & Cannle, McGraw-Hill, 1985
%
% Usage:
%         [tout, xout] = ode45(FUN, tspan, x0, pair, ode_fcn_format, tol, trace, count)
%
% INPUT:
% FUN   - String containing name of user-supplied problem description.
%         Call: xprime = fun(t,x) where FUN = 'fun'.
%         t      - Time (scalar).
%         x      - Solution column-vector.
%         xprime - Returned derivative COLUMN-vector; xprime(i) = dx(i)/dt.
% tspan - [ tstart, tfinal ]
% x0    - Initial value COLUMN-vector.
% pair  - flag specifying which integrator coefficients to use:
%            0 --> use Dormand-Prince 4(5) pair (default)
%            1 --> use Fehlberg pair 4(5) pair
% ode_fcn_format - this specifies if the user-defined ode function is in
%         the form:     xprime = fun(t,x)   (ode_fcn_format=0, default)
%         or:           xprime = fun(x,t)   (ode_fcn_format=1)
%         Matlab's solvers comply with ode_fcn_format=0 while
%         Octave's lsode() and sdirk4() solvers comply with ode_fcn_format=1.
% tol   - The desired accuracy. (optional, default: tol = 1.e-6).
% trace - If nonzero, each step is printed. (optional, default: trace = 0).
% count - if nonzero, variable 'rhs_counter' is initalized, made global
%         and counts the number of state-dot function evaluations
%         'rhs_counter' is incremented in here, not in the state-dot file
%         simply make 'rhs_counter' global in the file that calls ode45
%
% OUTPUT:
% tout  - Returned integration time points (column-vector).
% xout  - Returned solution, one solution column-vector per tout-value.
%
% The result can be displayed by: plot(tout, xout).
%
% Marc Compere
% CompereM@asme.org
% created : 06 October 1999
% modified: 17 January 2001
if nargin < 8, count = 0; end
if nargin < 7, trace = 0; end
if nargin < 6, tol = 1.e-6; end
if nargin < 5, ode_fcn_format = 0; end
if nargin < 4, pair = 0; end

pow = 1/6; % see p.91 in the Ascher & Petzold reference for more infomation.

% Use the Dormand-Prince 4(5) coefficients:
a_(1,1)=0;
a_(2,1)=1/5;
a_(3,1)=3/40; a_(3,2)=9/40;
a_(4,1)=44/45; a_(4,2)=-56/15; a_(4,3)=32/9;
a_(5,1)=19372/6561; a_(5,2)=-25360/2187; a_(5,3)=64448/6561; a_(5,4)=-212/729;
a_(6,1)=9017/3168; a_(6,2)=-355/33; a_(6,3)=46732/5247; a_(6,4)=49/176; a_(6,5)=-5103/18656;
a_(7,1)=35/384; a_(7,2)=0; a_(7,3)=500/1113; a_(7,4)=125/192; a_(7,5)=-2187/6784; a_(7,6)=11/84;
% 4th order b-coefficients
b4_(1,1)=5179/57600; b4_(2,1)=0; b4_(3,1)=7571/16695; b4_(4,1)=393/640; b4_(5,1)=-92097/339200; b4_(6,1)=187/2100; b4_(7,1)=1/40;
% 5th order b-coefficients
b5_(1,1)=35/384; b5_(2,1)=0; b5_(3,1)=500/1113; b5_(4,1)=125/192; b5_(5,1)=-2187/6784; b5_(6,1)=11/84; b5_(7,1)=0;
for i=1:7,
    c_(i)=sum(a_(i,:));
end
%else, % pair==1 so use the Fehlberg 4(5) coefficients:
%    a_(1,1)=0;
%    a_(2,1)=1/4;
%    a_(3,1)=3/32; a_(3,2)=9/32;
%    a_(4,1)=1932/2197; a_(4,2)=-7200/2197; a_(4,3)=7296/2197;
%    a_(5,1)=439/216; a_(5,2)=-8; a_(5,3)=3680/513; a_(5,4)=-845/4104;
%    a_(6,1)=-8/27; a_(6,2)=2; a_(6,3)=-3544/2565; a_(6,4)=1859/4104; a_(6,5)=-11/40;
%    % 4th order b-coefficients (guaranteed to be a column vector)
%    b4_(1,1)=25/216; b4_(2,1)=0; b4_(3,1)=1408/2565; b4_(4,1)=2197/4104; b4_(5,1)=-1/5;
%    % 5th order b-coefficients (also guaranteed to be a column vector)
%    b5_(1,1)=16/135; b5_(2,1)=0; b5_(3,1)=6656/12825; b5_(4,1)=28561/56430; b5_(5,1)=-9/50; b5_(6,1)=2/55;
%    for i=1:6,
%     c_(i)=sum(a_(i,:));
%    end

[i N] = size(tspan);
deptout = tspan(1);             % first output time
depxout = x0(:)';           % first output solution
for i=1:1:N-1
% Initialization
t0 = tspan(i);
tfinal = tspan(i+1);
t = t0;
hmax = (tfinal - t)/2.5;
hmin = (tfinal - t)/1e9;
h = (tfinal - t)/100; % initial guess at a step size
[M k] = size(depxout);
x = depxout(M,:)'; % this always creates a column vector, x
if count==1,
 global rhs_counter
 if ~exist('rhs_counter'),rhs_counter=0; end
end % if count

if trace
 clc, t, h, x
end

   k_ = x*zeros(1,7);  % k_ needs to be initialized as an Nx7 matrix where N=number of rows in x
                       % (just for speed so octave doesn't need to allocate more memory at each stage value)

   % Compute the first stage prior to the main loop.  This is part of the Dormand-Prince pair caveat.
   % Normally, during the main loop the last stage for x(k) is the first stage for computing x(k+1).
   % So, the very first integration step requires 7 function evaluations, then each subsequent step
   % 6 function evaluations because the first stage is simply assigned from the last step's last stage.
   % note: you can see this by the last element in c_ is 1.0, thus t+c_(7)*h = t+h, ergo, the next step.
   if (ode_fcn_format==0), % (default)
      k_(:,1)=feval(FUN,t,x); % first stage
   else, % ode_fcn_format==1
      k_(:,1)=feval(FUN,x,t);
   end % if (ode_fcn_format==1)

   % increment rhs_counter
   if (count==1), rhs_counter = rhs_counter + 1; end

   % The main loop using Dormand-Prince 4(5) pair
   while (t < tfinal) & (h >= hmin),
      if t + h > tfinal, h = tfinal - t; end

      % Compute the slopes by computing the k(:,j+1)'th column based on the previous k(:,1:j) columns
      % notes: k_ needs to end up as an Nxs, a_ is 7x6, which is s by (s-1),
      %        s is the number of intermediate RK stages on [t (t+h)] (Dormand-Prince has s=7 stages)
      if (ode_fcn_format==0), % (default)
         for j = 1:6,
            k_(:,j+1) = feval(FUN, t+c_(j+1)*h, x+h*k_(:,1:j)*a_(j+1,1:j)');
         end
      else, % ode_fcn_format==1
         for j = 1:6,
            k_(:,j+1) = feval(FUN, x+h*k_(:,1:j)*a_(j+1,1:j)', t+c_(j+1)*h);
         end
      end % if (ode_fcn_format==1)

      % increment rhs_counter
      if (count==1), rhs_counter = rhs_counter + 6; end

      % compute the 4th order estimate
      x4=x + h* (k_*b4_); % k_ is Nxs (or Nx7) and b4_ is a 7x1

      % compute the 5th order estimate
      x5=x + h*(k_*b5_); % k_ is Nxs (or Nx7) and b5_ is a 7x1

      % estimate the local truncation error
      gamma1 = x5 - x4;

      % Estimate the error and the acceptable error
      delta = norm(gamma1,'inf');       % actual error
      tau = tol*max(norm(x,'inf'),1.0); % allowable error

      % Update the solution only if the error is acceptable
      if (delta<=tau),
         t = t + h;
         x = x5;    % <-- using the higher order estimate is called 'local extrapolation'
         deptout = [deptout; t];
         depxout = [depxout; x'];
      end % if (delta<=tau)

      if trace
         home, t, h, x
      end % if trace

      % Update the step size
      if (delta==0.0),
       delta = 1e-16;
      end % if (delta==0.0)
      h = min(hmax, 0.8*h*(tau/delta)^pow);

      % Assign the last stage for x(k) as the first stage for computing x(k+1).
      % This is part of the Dormand-Prince pair caveat.
      % k_(:,7) has already been computed, so use it instead of recomputing it
      % again as k_(:,1) during the next step.
      k_(:,1)=k_(:,7);
   end % while (t < tfinal) & (h >= hmin)

   if (t < tfinal)
        disp('Step size grew too small.')
        t, h, x
   end
%x0 = x(:);
end
xout = depxout;
tout = deptout;

