function [stepsize,xo,Ot,nS]=coggins(S,x0,d,ip,problem,tol,mxit,stp)
%   Performs line search procedure for unconstrained optimization
%   using quadratic interpolation.
%
%   [stepsize,xo,Ot,nS]=coggins(S,x0,d,ip,problem,tol,mxit)
%
%   S: objective function
%   x0: initial point
%   d: search direction vector
%   ip: (0): no plot (default), (>0) plot figure ip with pause, (<0) plot figure ip
%   problem: (-1): minimum (default), (1): maximum
%   tol: tolerance (default = 1e-4)
%   mxit: maximum number of iterations (default = 50*(1+4*~(ip>0)))
%   stp: initial stepsize (default = 0.01*sqrt(d'*d))
%   stepsize: optimal stepsize
%   xo: optimal point in the search direction
%   Ot: optimal value of S in the search direction
%   nS: number of objective function evaluations

%   Copyright (c) 2001 by LASIM-DEQUI-UFRGS
%   $Revision: 1.0 $  $Date: 2001/07/04 21:20:15 $
%   Argimiro R. Secchi (arge@enq.ufrgs.br)
 
 if nargin < 3,
   error('coggins requires three input arguments');
 end
 if nargin < 4 | isempty(ip),
   ip=0;
 end
 if nargin < 5 | isempty(problem),
   problem=-1;
 end
 if nargin < 6 | isempty(tol),
   tol=1e-4;
 end
 if nargin < 7 | isempty(mxit),
   mxit=50*(1+4*~(ip>0));
 end

 d=d(:);
 nd=d'*d;

 if nargin < 8 | isempty(stp),
   stepsize=0.01*sqrt(nd);
 else
   stepsize=abs(stp);
 end

 x0=x0(:);
 [x1,x2,nS]=bracket(S,x0,d,problem,stepsize);
 z(1)=d'*(x1-x0)/nd;
 y(1)=feval(S,x1)*problem;
 z(3)=d'*(x2-x0)/nd;
 y(3)=feval(S,x2)*problem;
 z(2)=0.5*(z(3)+z(1));
 x=x0+z(2)*d;
 y(2)=feval(S,x)*problem;
 nS=nS+3;
 
 if ip,
   figure(abs(ip)); clf;
   B=sort([z(1),z(3)]);
   b1=0.05*(abs(B(1))+~B(1));
   b2=0.05*(abs(B(2))+~B(2));
   X1=(B(1)-b1):(B(2)-B(1)+b1+b2)/20:(B(2)+b2);
   n1=size(X1,2);
   for i=1:n1,
     f(i)=feval(S,x0+X1(i)*d);
   end   
   plot(X1,f,'b',X1(1),f(1),'g'); axis(axis); hold on;
   legend('S(x0+\alpha d)','P_2(x0+\alpha d)');
   xlabel('\alpha');
   plot([B(1),B(1)],[-1/eps 1/eps],'k');
   plot([B(2),B(2)],[-1/eps 1/eps],'k');
   plot(z,y*problem,'ro');
   if ip > 0,
     disp('Pause: hit any key to continue...'); pause;
   end
 end
 
 it=0;
 while it < mxit,
   a1=z(2)-z(3); a2=z(3)-z(1); a3=z(1)-z(2);
   if y(1)==y(2) & y(2)==y(3),
     zo=z(2);
     x=x0+zo*d;
     ym=y(2);
   else
     zo=.5*(a1*(z(2)+z(3))*y(1)+a2*(z(3)+z(1))*y(2)+a3*(z(1)+z(2))*y(3))/ ...
        (a1*y(1)+a2*y(2)+a3*y(3));
     x=x0+zo*d;
     ym=feval(S,x)*problem;
     nS=nS+1;
   end
   
   if ip,
     P2=-((X1-z(2)).*(X1-z(3))*y(1)/(a3*a2)+(X1-z(1)).*(X1-z(3))*y(2)/(a3*a1)+ ...
        (X1-z(1)).*(X1-z(2))*y(3)/(a2*a1))*problem;
     plot(X1,P2,'g');
     if ip > 0,
       disp('Pause: hit any key to continue...'); pause;
     end
     plot(zo,ym*problem,'ro');
   end

   for j=1:3,
    if abs(z(j)-zo) < tol*(0.1+abs(zo)),
      stepsize=zo;
      xo=x;
      Ot=ym*problem;
      
      if ip,
        plot(stepsize,Ot,'r*');
      end
      return;
    end
   end

   if (z(3)-zo)*(zo-z(2)) > 0,
     j=1;
   else
     j=3;
   end
    
   if ym > y(2),
     z(j)=z(2);
     y(j)=y(2);
     j=2;
   end
    
   y(4-j)=ym;
   z(4-j)=zo;
   it=it+1;
 end

 if it == mxit
  disp('Warning Coggins: reached maximum number of iterations!');
 end

 stepsize=zo;
 xo=x;
 Ot=ym*problem;
