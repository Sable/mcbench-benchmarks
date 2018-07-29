function [stepsize,xo,Ot,nS]=aurea(S,x0,d,ip,problem,tol,mxit,stp)
%   Performs line search procedure for unconstrained optimization
%   using golden section.
%
%   [stepsize,xo,Ot,nS]=aurea(S,x0,d,ip,problem,tol,mxit,stp)
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
%   $Revision: 1.0 $  $Date: 2001/07/04 22:30:45 $
%   Argimiro R. Secchi (arge@enq.ufrgs.br)

 if nargin < 3,
   error('aurea requires three input arguments');
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
 z(2)=d'*(x2-x0)/nd;

 fi=.618033985;
 k=0;
 secao=fi*(z(2)-z(1));
 p(1)=z(1)+secao;
 x=x0+p(1)*d;
 y(1)=feval(S,x)*problem;
 p(2)=z(2)-secao;
 x=x0+p(2)*d;
 y(2)=feval(S,x)*problem;
 nS=nS+2;

 if ip,
   figure(abs(ip)); clf;
   c=['m','g'];
   B=sort([z(1),z(2)]);
   b1=0.05*(abs(B(1))+~B(1));
   b2=0.05*(abs(B(2))+~B(2));
   X1=(B(1)-b1):(B(2)-B(1)+b1+b2)/20:(B(2)+b2);
   n1=size(X1,2);
   for i=1:n1,
     f(i)=feval(S,x0+X1(i)*d);
   end   
   plot(X1,f,'b'); axis(axis); hold on;
   legend('S(x0+\alpha d)');
   xlabel('\alpha');
   plot([B(1),B(1)],[-1/eps 1/eps],'k');
   plot([B(2),B(2)],[-1/eps 1/eps],'k');
   plot(p,y*problem,'ro');
   if ip > 0,
     disp('Pause: hit any key to continue...'); pause;
   end
 end
 
 it=0;
 while abs(secao/fi) > tol & it < mxit,
   if y(2) < y(1),
     j=2; k=1;
   else
     j=1; k=2;
   end
   
   z(k)=p(j);
   p(j)=p(k);
   y(j)=y(k);
   secao=fi*(z(2)-z(1));
   p(k)=z(k)+(j-k)*secao;
   x=x0+p(k)*d;
   y(k)=feval(S,x)*problem;
   nS=nS+1;
   
   if ip,
     plot([z(k),z(k)],[-1/eps 1/eps],c(k));
     plot(p(k),y(k)*problem,'ro');
     if ip > 0,
       disp('Pause: hit any key to continue...'); pause;
     end
   end
   
   it=it+1;
 end

 stepsize=p(k);
 xo=x; 
 Ot=y(k)*problem;  

 if it == mxit
  disp('Warning Aurea: reached maximum number of iterations!');
 elseif ip,
   plot(stepsize,Ot,'r*');
 end
