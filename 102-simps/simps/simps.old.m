function [x,options]=simps(fun,x,ix,options,vlb,vub,varargin)
%SIMPS (Strategy Simplex) finds the constrained minimum.
%
%   Syntax:
%   [X1,OPTIONS]=SIMPS(FUN,X0,IX,OPTIONS,VLB,VUB,P1,P2...)
%   where IX,OPTIONS,VLB,VUB,P1,P2... are optional.
%
%   Compare to Matlab's functions:
%   [X1,OPTIONS]=FMINS(FUN,X0,OPTIONS,[],P1,P2...)
%   [X1,OPTIONS]=CONSTR(FUN,X0,OPTIONS,VLB,VUB,[],P1,P2...) - OPTIM
%   toolbox
%
%   'FUN' - function to be minimized (usually an M-file: FUN.M).
%   It must be of the form: [F,G]=FUN(X,P1,P2...), where F returns the
%   value, and G returns the vector of constraints.
%   Constraints are satisfied at the point X if the respective
%   components of G are non-positive. For the non-constrained
%   minimization, use G=[].
%   The point X can be a [real] vector, matrix, or several dimensional
%   array. Both F and G must be well defined for all VLB<=X<=VUB (see
%   below).
%   P1,P2... are optional problem-dependent parameters, bypassed by
%   the minimizer SIMPS.
%
%   X0 - initial guess,
%   X1 - point of minimum as obtained;
%   both of the same type and dimension as X in the function 'FUN'.
%
%   IX - integer vector, subset of 1:PROD(SIZE(X0)) (which is also its
%   default value). The minimization is performed only against X0(IX),
%   while the other components of X0 are supposed to be fixed.
%   Let us denote LX=LENGTH(IX).
%
%   OPTIONS - see FOPTIONS. Only the following components are used:
%   Input:
%   OPTIONS(1)  - Whether to display intermediate results (1),
%                 or not (0, default).
%   OPTIONS(2)  - Relative X-termination tolerance (default: 1e-4).
%   OPTIONS(3)  - Relative F-termination tolerance (default: 1e-4).
%   OPTIONS(14) - Maximum number of function evaluations per each
%                 internal LX-dim. and 2-dim. simplex call
%                 (default: 100*LX).
%   Output:
%   OPTIONS(8)  - Function value at the point X1 (minimum).
%   OPTIONS(10) - Total number of function evaluations.
%
%   VLB,VUB - lower and upper bounds for X.
%   Both must be vectors of length PROD(SIZE(X0)) - total number of
%   components of X0.
%   Supply -INF, resp. +INF, (default) for unrestricted coordinates.
%
%   Comments:
%
%   - SIMPS is an iterative method, where each iteration consists of
%   one LX (full dim.) Nelder-Mead simplex call (direct search),
%   followed by LX+1 two dim. Nelder-Mead simplex calls (working on 2
%   dim. subspaces). These LX+1 two-dim. simplex calls provide initial
%   vertices V for the next full dim. simplex call (next iteration).
%
%   - The number of outer iterations is limited to LX or until the
%   longest dimension of simplex V (see above) falls below the
%   X-tolerance (OPTIONS(2)).
%   The internal LX and 2 dim. simplex calls are limited by proposed
%   F-tolerance or max. number of function evaluations (OPTIONS(2) and
%   OPTIONS(14)).
%
%   - The inner LX and 2 dim. Nelder-Mead minimizers are both realized
%   through the calls to the internal AMOEBA function, based
%   essentially on the code of the Matlab's FMINS non-linear simplex
%   implementation.
%
%   - The constraints are basically implemented by penalizing the
%   function (see the internal WRAPPER function): unsatisfied
%   constraints (-sum(G(find(G<0))), multiplied by factor 1e6, are
%   being added to the function value F.
%
%   - The index vector IX provides a useful and convenient method for
%   numerical experiments with complicated unknown minima, allowing to
%   user to perform searches limited to smaller dimensional subspaces.
%   This extra feature does not require run-time editing on the side
%   of target function 'FUN', as would be the case if certain
%   variables were fixed by use of optional parameters P1,P2...
%
%   - In contrast to the Matlab's FMINS, CONSTR and other minimizers,
%   both X and F termination tolerances are considered relative, not
%   absolute.
%   Nevertheless, X, F and G should be ideally of the same order of
%   magnitude (1), at least locally around the point of minimum.
%
%   - There is of course no guarantee that the output X1 represents
%   the point of global minimum as required.
%   However, the method (strategy) provides an advantage over the
%   plain nonlinear simplex, and it has been proved to be specially
%   useful for target functions with plenty of narrow local minima -
%   standard traps for analitically based minimizers.
%   The method is not limited to continuos functions and does not
%   require derivatives.
%
%   Authors:
%   Zeljko Bajzer (bajzer@mayo.edu) and Ivo Penzar (penzar@mayo.edu)
%   Mayo Clinic and Foundation, Rochester, Minnesota, USA
%   June, 1998.

if nargin<2, error('simps requires two input arguments'); end
if nargin<3, ix=1:prod(size(x)); end
ix=unique(ix); lx=length(ix);
if nargin<4, options=[]; end
if nargin<5, vlb=-Inf+zeros(size(1,lx)); end
if nargin<6, vub=Inf+zeros(size(1,lx)); end

options=foptions(options);
prnt=options(1);
if ~options(14)
 options(14)=50*lx;
end
tolx=options(2);
tolf=options(3);
maxfcalls=options(14);

varargs={vlb,vub,fun,varargin{:}};

xx=x(ix)';
if all(abs(xx)<eps)
 xx=xx+eps;
end
d=0.5;
% Guess goes to the centre:
%v=repmat((1-d/(lx+1))*xx,1,lx+1)+[diag(d*xx) zeros(lx,1)];
% Guess goes to a corner:
v=repmat(xx,1,lx+1)+[diag(d*xx) zeros(lx,1)];
fcalls=0; dv=Inf;
if prnt
 fprintf('%7s %10s %12s\n','f-COUNT','FUNCTION','x-TOL');
end
i=0;
while (i<lx)&(dv>=tolx)
 [y,fmin,tmp4]=amoeba(v,tolf,maxfcalls,...
                      x,ix,varargs{:});
 y=y'; x(ix)=y;
 fcalls=fcalls+tmp4;
 if prnt
  fprintf('%7d %10.5f\n',fcalls,fmin);
 end
 if lx==1
  break
 end
 if lx==2
  v(:,1)=y;
 else
  for j=1:lx-1
   j1=[j j+1];
   [y(j1),fmin,tmp4]=amoeba([xx(j1) y(j1) [xx(j1(1)) y(j1(2))]'],...
                            tolf,maxfcalls,...
                            x,ix(j1),varargs{:});
   x(ix)=y; v(:,j)=y;
   fcalls=fcalls+tmp4;
  end
 end
 j1=[1 lx];
 [y(j1),fmin,tmp4]=amoeba([xx(j1) y(j1) [xx(j1(1)) y(j1(2))]'],...
                          tolf,maxfcalls,...
                          x,ix(j1),varargs{:});
 x(ix)=y; v(:,lx)=y;
 fcalls=fcalls+tmp4;
 if lx>3
  j1=[2 lx-1];
 end
 [y(j1),fmin,tmp4]=amoeba([xx(j1) y(j1) [y(j1(1)) xx(j1(2))]'],...
                          tolf,maxfcalls,...
                          x,ix(j1),varargs{:});
 x(ix)=y; v(:,lx+1)=y;
 fcalls=fcalls+tmp4;
 dv=max(tol(min(v,[],2),max(v,[],2)));
 if prnt
  fprintf('%7d %10.5f %12.6f\n',fcalls,fmin,dv);
 end
 i=i+1;
end
if prnt
 fprintf('\n');
end

options(8)=fmin;
options(10)=fcalls;

return


function [x,fmin,fcalls]=amoeba(v,tolf,maxfcalls,varargin)
% Internal Nelder-Mead minimizer, based essentially on the code
% of the Matlab's FMINS non-linear simplex implementation.
%
% - Input and output parameters are changed
%   (e.g., initial simplex v is provided from outside);
% - There is no x-tolerance termination checking;
% - There is no display of intermediate results.

rho=1; chi=2; psi=0.5; sigma=0.5;

n=length(v(:,1));
onesn=ones(1,n);
two2np1=2:n+1;
one2n=1:n;
zerosn=zeros(1,n);
x=zerosn;

fv=zeros(1,n+1);
for j=1:n+1
 x(:)=v(:,j);
 fv(j)=wrapper(x,varargin{:});
end
[fv,jj]=sort(fv);
v=v(:,jj);
fmin=fv(1); fcalls=n+1;

while (fcalls<maxfcalls)&...
      (tol(fmin,fv(n+1))>tolf)
 shrink=0;
 xbar=sum(v(:,one2n),2)/n;
 xr=(1+rho)*xbar-rho*v(:,n+1);
 x(:)=xr;
 fxr=wrapper(x,varargin{:});
 fcalls=fcalls+1;

 if fxr<fv(1)
  xe=(1+rho*chi)*xbar-rho*chi*v(:,n+1);
  x(:)=xe;
  fxe=wrapper(x,varargin{:});
  fcalls=fcalls+1;
  if fxe<fxr
   v(:,n+1)=xe;
   fv(n+1)=fxe;
  else
   v(:,n+1)=xr;
   fv(n+1)=fxr;
  end

 elseif fxr<fv(n)
  v(:,n+1)=xr;
  fv(n+1)=fxr;

 else
  if fxr<fv(n+1)
   xc=(1+psi*rho)*xbar-psi*rho*v(:,n+1);
   x(:)=xc;
   fxc=wrapper(x,varargin{:});
   fcalls=fcalls+1;
   if fxc<=fxr
    v(:,n+1)=xc;
    fv(n+1)=fxc;
   else
    shrink=1;
   end
  else
   xcc=(1-psi)*xbar+psi*v(:,n+1);
   x(:)=xcc;
   fxcc=wrapper(x,varargin{:});
   fcalls=fcalls+1;
   if fxcc<fv(n+1)
    v(:,n+1)=xcc;
    fv(n+1)=fxcc;
   else
    shrink=1;
   end
  end
  if shrink
   for j=two2np1
    v(:,j)=v(:,1)+sigma*(v(:,j)-v(:,1));
    x(:)=v(:,j);
    fxcc=wrapper(x,varargin{:});
   end
   fcalls=fcalls+n;
  end
 end

 [fv,jj]=sort(fv);
 v=v(:,jj);
 fmin=fv(1);
end
x(:)=v(:,1);

return


function r=tol(a,b)
% Internal helper function, calculates the relative distances
% between points a and b, componentwise.

c=(abs(b)+abs(a))/2;
j=find(c<eps); c(j)=ones(size(j));
r=abs(b-a)./c;

return


function fmin=wrapper(x,x0,ix,vlb,vub,funfcn,varargin)
% Internal wrapper function, provides a proper interface for
% AMOEBA to the user's target function.

x1=zeros(1,prod(size(x0)));
x1(:)=x0;
x1(ix)=x;
x0(:)=max(min(x1,vub),vlb);

funfcn=fcnchk(funfcn,1+length(varargin));
[fmin,fconstr]=feval(funfcn,x0,varargin{:});

fconstr=[vlb-x1,x1-vub,fconstr];
fmin=fmin+1e6*sum(fconstr(find(fconstr>0)));

return


