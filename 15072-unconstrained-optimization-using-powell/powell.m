function [xo,Ot,nS]=powell(S,x0,ip,method,Lb,Ub,problem,tol,mxit)
%   Unconstrained optimization using Powell.
%
%   [xo,Ot,nS]=powell(S,x0,ip,method,Lb,Ub,problem,tol,mxit)
%
%   S: objective function
%   x0: initial point
%   ip: (0): no plot (default), (>0) plot figure ip with pause, (<0) plot figure ip
%   method: (0) Coggins (default), (1): Golden Section
%   Lb, Ub: lower and upper bound vectors to plot (default = x0*(1+/-2))
%   problem: (-1): minimum (default), (1): maximum
%   tol: tolerance (default = 1e-4)
%   mxit: maximum number of stages (default = 50*(1+4*~(ip>0)))
%   xo: optimal point
%   Ot: optimal value of S
%   nS: number of objective function evaluations

%   Copyright (c) 2001 by LASIM-DEQUI-UFRGS
%   $Revision: 1.0 $  $Date: 2001/07/07 21:10:15 $
%   Argimiro R. Secchi (arge@enq.ufrgs.br)

 if nargin < 2,
   error('powell requires two input arguments');
 end
 if nargin < 3 | isempty(ip),
   ip=0;
 end
  if nargin < 4 | isempty(method),
   method=0;
 end
 if nargin < 5 | isempty(Lb),
   Lb=-x0-~x0;
 end
 if nargin < 6 | isempty(Ub),
   Ub=2*x0+~x0;
 end
 if nargin < 7 | isempty(problem),
   problem=-1;
 end
 if nargin < 8 | isempty(tol),
   tol=1e-4;
 end
 if nargin < 9 | isempty(mxit),
   mxit=50*(1+4*~(ip>0));
 end

 x0=x0(:);
 y0=feval(S,x0)*problem;
 n=size(x0,1);
 D=eye(n);
 ips=ip;
  
 if ip & n == 2,
   figure(abs(ip));
   [X1,X2]=meshgrid(Lb(1):(Ub(1)-Lb(1))/20:Ub(1),Lb(2):(Ub(2)-Lb(2))/20:Ub(2));
   [n1,n2]=size(X1);
   f=zeros(n1,n2);
   for i=1:n1,
    for j=1:n2,
      f(i,j)=feval(S,[X1(i,j);X2(i,j)]);
    end
   end
   mxf=max(max(f));
   mnf=min(min(f));
   df=mnf+(mxf-mnf)*(2.^(([0:10]/10).^2)-1);
   [v,h]=contour(X1,X2,f,df); hold on;
%   clabel(v,h);
   h1=plot(x0(1),x0(2),'ro');
   legend(h1,'start point');

   if ip > 0,
     ips=ip+1;
     disp('Pause: hit any key to continue...'); pause;
   else
     ips=ip-1;
   end
 end
 
 xo=x0;
 yo=y0;
 it=0;
 nS=1;
 
 while it < mxit,
                     % exploration
  delta=0;
  for i=1:n,
     if method,           % to see the linesearch plot, remove the two 0* below
       [stepsize,x,Ot,nS1]=aurea(S,xo,D(:,i),0*ips,problem,tol,mxit);
       Ot=Ot*problem;
     else
       [stepsize,x,Ot,nS1]=coggins(S,xo,D(:,i),0*ips,problem,tol,mxit);
       Ot=Ot*problem;
     end
     
     nS=nS+nS1;
     di=Ot-yo;
     if di > delta,
       delta=di;
       k=i;
     end

     if ip & n == 2,
       plot([x(1) xo(1)],[x(2) xo(2)],'r');
       if ip > 0,
         disp('Pause: hit any key to continue...'); pause;
       end
     end

     yo=Ot;
     xo=x;
  end
                  % progression
  it=it+1;
  xo=2*x-x0;
  Ot=feval(S,xo)*problem;
  nS=nS+1;
  di=y0-Ot;

  j=0;
  if di >= 0 | 2*(y0-2*yo+Ot)*((y0-yo-delta)/di)^2 >= delta,
    if Ot >= yo,
      yo=Ot;
    else
      xo=x;
      j=1;
    end
  else
    if k < n,
      D(:,k:n-1)=D(:,k+1:n);
    end
    D(:,n)=(x-x0)/norm(x-x0);
    if method,           % to see the linesearch plot, remove the two 0* below
      [stepsize,xo,yo,nS1]=aurea(S,x,D(:,n),0*ips,problem,tol,mxit);
      yo=yo*problem;
    else
      [stepsize,xo,yo,nS1]=coggins(S,x,D(:,n),0*ips,problem,tol,mxit);
      yo=yo*problem;
    end
     
    nS=nS+nS1;
  end

  if ip & n == 2 & ~j,
    plot([x(1) xo(1)],[x(2) xo(2)],'r');
    if ip > 0,
      disp('Pause: hit any key to continue...'); pause;
    end
  end
  
  if norm(xo-x0) < tol*(0.1+norm(x0)) & abs(yo-y0) < tol*(0.1+abs(y0)),
    break;
  end

  y0=yo;
  x0=xo;
 end
 
 Ot=yo*problem;
 
 if it == mxit,
   disp('Warning Powell: reached maximum number of stages!');
 elseif ip & n == 2,
   h2=plot(xo(1),xo(2),'r*');
   legend([h1,h2],'start point','optimum');
 end
