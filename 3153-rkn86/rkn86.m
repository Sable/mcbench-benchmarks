function [tout, yout ,dyout,iaccept,ireject] = rkn86(FunFcn, t0, tfinal, y0, dy0, tol);
%   rkn86 Integrates a special system of ordinary differential equations using 
%   an effectivelly 8-stages Runge-Kutta-Nystrom pair of orders 8 and 6.
%
%	[T,Y,DY,IA,IR] = rkn86('yprime', T0, Tfinal, Y0, DY0) integrates the special system
%	of second order ordinary differential equations of the form:
%
%   y''=f(t,y), y(t0)=y0, y'(t0)=y'0
%
%   described by the M-file YPRIME.M over the interval T0 to Tfinal. 
%
%	[T,Y,DY,IA,IR] = rkn86(F, T0, Tfinal, Y0, DY0, TOL) uses tolerance TOL
%
% INPUT:
% F     - String containing name of user-supplied problem description.
%         Call: yprime = fun(t,y) where F = 'fun'.
%         t      - Time (scalar).
%         y      - Solution column-vector.
%         yprime - Returned derivative column-vector; yprime(i) = d^2y(i)/dt^2.
% t0    - Initial value of t.
% tfinal- Final value of t.
% y0    - Initial value column-vector.
% dy0   - Initial derivatives column vector
% tol   - The desired accuracy. (Default: tol = 1.e-6).
%
% OUTPUT:
% T       - Returned integration time points (row-vector).
% Y       - Returned solution, one solution column-vector per tout-value.
% DY      - Returned derivative solution,
% Iaccept - Returned number of accepted steps
% Ireject - Returned number of rejected steps
%
% The result can be displayed by: plot(tout, yout).
%
% Example: Solve two-body problem using inline 
% the problem :
%              y1''=-y1/(y1^2+y2^2)^1.5, y2''=-y2/(y1^2+y2^2)^1.5
%              Initial contitions y1(0)=.5, y2(0)=0, y1'(0)=0, y2'(0)=3^0.5
% Matlab call :
%              [x,y]=rkn86(inline('[-y(1)/sqrt(y(1)^2+y(2)^2)^3;-y(2)/sqrt(y(1)^2+y(2)^2)^3]','x','y'), ...
%              0, 20, [.5 0]',[0 sqrt(3)]', 1e-11);
% write       : plot(y(:,1),y(:,2),'-k'); % to get the elliptic orbit
% 
% based on  the code ODE86 by Ch. Tsitouras 
%
% The coefficients of the Runge-Kutta-Nystrom pair NEW8(6) are taken from 
% S. N. Papakostas and Ch. Tsitouras, "High phase-lag order Runge-Kutta and Nystrom pairs",
% SIAM J. Sci. Comput. 21(1999) 747-763.
%
% The error control is based on
% Ch. Tsitouras and S. N. Papakostas, "Cheap Error Estimation for Runge-Kutta
% methods", SIAM J. Sci. Comput. 20(1999) 2067-2088.

% Matlab version : 6.1
% Author : Ch. Tsitouras, 1996-2003.
% URL address: http://users.ntua.gr/tsitoura/
%---------------------------------------------------------------------------
% the coefficients
alpha=[0 6397/98811 12794/98811 14/37 8/13 17/22 43/46 1 1]';

beta=[[0 0 0 0 0 0 0 0 0]
[21738209/10373173531 0 0 0 0 0 0 0 0]
[81843218/29290841163 82694821/14797810534 0 0 0 0 0 0 0]
[286557584/4330809711 -912003620/7090326959 2215175292/16525689869 0 0 0 0 0 0]
[-1732991908/3477246155 20699018807/16215676961 -8943798416/12438207277 711229321/5458138039 0 0 0 0 0]
[10259024870/9108477419 -25149249362/9340973033 4686267579/2513053636 -326162972/7839732939 556579829/13434269006 0 0 0 0]
[-32801447959/18176875798 31592171746/6958893399 -111550006196/40089394711 3451154231/7987305225 68790340/8728368029 123716081/2797556961 0 0 0]
[62469663917/6900212338 -171339392336/7672895439 262962495363/17824923050 -22108842829/16963055973 661764535/1698709821 -238225641/2934789434 260644226/13286668711 0 0]
[257873323/6918876884 0 1503948753/8413843957 2236434251/13285504895 1069201912/15512587877 980034039/25364950097 92941557/11497613663 0 0]]';

gamma=[[257873323/6918876884 0 1503948753/8413843957 2236434251/13285504895 1069201912/15512587877 980034039/25364950097 92941557/11497613663 0 0]
[-108540447/9734693747 0 216990433/7248923167 -693180867/13981264399 783383731/11490287817 -639183288/13156494967 143178476/12783609495 0 0]]';

dgamma=[[257873323/6918876884 0 1885846298/9184313637 10010095879/36964622736 576314810/3215962383 378512797/2226489968 1523915682/12294818705 13956454/1038655275 0]
[-108540447/9734693747 0 300730357/8745591283 -339555838/4257328827 4673474889/26364705520 -1278366576/5980224985 1108173697/6452782413 411153357/5767449338 -3/20]*3]';
%----------------------------------------------------------------------
ireject=0;iaccept=0;
pow = 1/8;
if nargin < 6, tol = 1.e-6; end

% Initialization
t=t0;
y=y0;
dy=dy0;
tout = t0(:)';
yout = y0(:)';
dyout = dy0(:)';
hmax = (tfinal - t)/1;
hmin = (tfinal - t)/100000000;
f = y0*zeros(1,length(alpha));

% initial step
f(:,1) = feval(FunFcn,t,y);
h=tol^pow/max(max(abs([dy' f(:,1)'])),1e-2);
h=min(hmax,max(h,hmin));

% The main loop
   while (t < tfinal) & (h >= hmin)
      if t + h > tfinal, h = tfinal - t; end

      % Compute the slopes
      for j = 1:length(alpha),
         f(:,j) = feval(FunFcn, t+alpha(j)*h,y+alpha(j)*h*dy+h^2*f*beta(:,j));
      end

      % Estimate the error and the acceptable error
      delta1 = max(abs(h^2*f*gamma(:,2)));
      delta2 = max(abs(h*f*dgamma(:,2)));
      delta=max(delta1,delta2)*h;

      % Update the solution only if the error is acceptable
      if delta <= tol,
         t = t + h;
         y = y + h*dy+h^2*f*gamma(:,1);
         dy = dy +h*f*dgamma(:,1);
         iaccept=iaccept+1;
         tout=[tout; t];
         yout=[yout;y'];
         dyout=[dyout;dy'];
      else
         ireject=ireject+1;
      end

      if delta ~= 0.0
         h = min(hmax, .9*h*(tol/delta)^pow);
      end
   end;

   if (t < tfinal)
      disp('SINGULARITY LIKELY.')
   end
