function [int, tol1,ix]= quadg(fun,xlow,xhigh,tol,trace,p1,p2,p3,p4,p5,p6,p7,p8,p9)
%QUAUDG Numerically evaluates a  integral using a Gauss Legendre quadrature.
%
% CALL:
%  [int, tol] = quadg('Fun',xlow,xhigh,reltol,[trace,gn],p1,p2,....)
%
%      int = evaluated integral
%      tol = absolute tolerance abs(int-intold)
%      Fun = string containing the name of the function or a directly given 
%              expression enclosed in parenthesis. 
%      xlow,xhigh = integration limits
%      reltol = relative tolerance default=1e-3
%      trace = for non-zero TRACE traces the function evaluations 
%              with a point plot of the integrand.
%      gn = number of base points and weight points to start the 
%            integration with (default=2)
%    p1, p2, ...= coefficients to be passed directly to function Fun:   
%                  G = Fun(x,p1,p2,...).
%
% Note that int is the common size of xlow and xhigh.
% Example: integration from 0 to 2 and from 2 to 4 for x is done by:
%                        quadg('(x.^2)',[0 2],[2 4])

%This function works just like QUAD or QUAD8 but uses a Gaussian quadrature
%integration scheme.  Use this routine instead of QUAD or QUAD8:
%	if higher accuracy is desired (this works best if the function, 
%		'Fun', can be approximated by a power series) 
%	or if many similar integrations are going to be done (I think less
%		function evaluations will typically be done, but the 
%		integration points and the weights must be calculated.
%		These are saved between integrations so when QUADG
%		is called again, the points and weights are all ready
%		known.)
%	or if the function evaluations are time consuming.
%Note that if there are discontinuities the integral should be broken up into separate 
%pieces.  And if there are singularities,  a more appropriate integration quadrature
%should be used (such as the Gauss-Chebyshev).
% 

% modified by Per A. Brodtkorb 17.11.98 :
% -accept multiple integrationlimits, int is the common size of xlow and xhigh
% -optimized by only computing the integrals which did not converge.
%  - enabled the integration of directly given functions enclosed in 
%     parenthesis. Example: integration from 0 to 2 and from 2 to 4 for x is done by:
%                        quadg('(x.^2)',[0 2],[2 4])

% Reference 
%    see grule

%global b2
%global w2

if nargin<4| isempty(tol),
  tol=1e-3;
end

if nargin <5,
  trace=0; gn1=2;
elseif ~isempty(trace) ,
 if length(trace)==2,
  gn1=trace(2);
 else
   gn1=2;
 end
  trace=1;
 else
   trace=0; gn1=2;
end


if prod(size(xlow))==1,% make sure the integration limits have correct size
  xlow=xlow(ones(size(xhigh)));;
elseif prod(size(xhigh))==1,
  xhigh=xhigh(ones(size(xlow)));;
elseif any( size(xhigh)~=size(xlow) )
  error('The input must have equal size!')
end


if any(fun=='(')  & any(fun=='x'),
  exec_string=['y=',fun ';']; %the call function is already setup
else
  %setup string to call the function
  exec_string=['y=',fun,'(x'];
  num_parameters=nargin-5;
  for i=1:num_parameters,
    %if exist('p1') ~=1,
    xvar=['p' int2str(i)]; % variable # i
    if eval(['~ischar(' ,xvar,') &all(size(xlow)==size(' xvar,')) & length(',xvar,'(:)) ~=1' ]) ,
      eval([xvar, '=' ,xvar ,'(:);']); %make sure it is a column 
      exec_string=[exec_string,',' xvar '(k,ones(1,gn1) )']; %enable integration with multiple arguments
    else
      exec_string=[exec_string,',' xvar];
    end
  end
  exec_string=[exec_string,');'];
end
[N M]=size(xlow);

%setup mapping parameters
xlow=xlow(:);
jacob=(xhigh(:)-xlow(:))/2;
nk=N*M;%length of jacob
k=1:nk;

%generate the first two sets of integration points and weights
%if isempty(b2),
%  [b2 w2]=grule(2);
%end
%gn1=2;% # of weights

gntxt=int2str(gn1);% # of weights
eval(['global b',gntxt,' w',gntxt,';']);
if isempty(eval(['b',gntxt])) ,  % calculate the weights if necessary
   eval(['[b',gntxt,',w',gntxt,']=grule(',gntxt,');']);
end

eval(['x=(b',gntxt,'(ones(nk,1),:)+1).*jacob(k,ones(1, gn1 ))+xlow(k,ones(1,gn1 ));']);
%x=(b2(ones(nk,1),:)+1).*jacob(k,ones(1,gn1))+xlow(k,ones(1,gn1));

eval(exec_string);

%size(x),size(y),size(w2)
eval(['int=sum(w',gntxt,'(ones(nk,1),:).*y,2).*jacob(k);']);
%int_old=sum(w2(ones(nk,1),:).*y,2).*jacob;

int_old=int;
tol1=int;

if trace==1,
  x_trace=x(:);
  y_trace=y(:);
end

% Break out of the iteration loop for two reasons:
%  1) the last update is very small compared to int  (one might compare with tol aswell)
%  2) There are more than 11 iterations. This should NEVER happen. 

converge='n';
for i=1:11,
  gn1=gn1*2;% double the # of weights
  gntxt=int2str(gn1);% # of weights
  eval(['global b',gntxt,' w',gntxt,';']);
  if isempty(eval(['b',gntxt])) ,  % calculate the weights if necessary
    eval(['[b',gntxt,',w',gntxt,']=grule(',gntxt,');']);
  end
  eval(['x=(b',gntxt,'(ones(nk,1),:)+1).*jacob(k,ones(1, gn1 ))+xlow(k,ones(1,gn1 ));']);
  eval(exec_string);
  eval(['int(k)=sum(w',gntxt,'(ones(nk,1),:).*y,2).*jacob(k);']);

  if trace==1,
    x_trace=[x_trace;x(:)];
    y_trace=[y_trace;y(:)];
  end

  tol1(k)=abs(int_old(k)-int(k)); %absolute tolerance
  k=find(tol1 > abs(tol*int));%| tol1 > abs(tol));%indices to integrals which did not converge
   
  if any(k),% compute integrals again
      nk=length(k);%# of integrals we have to compute again
  else
    converge='y';
    break;
  end
  int_old=int;
end

int=reshape(int,N,M); % make sure int is the same size as the integration  limits
if nargout>1,
	tol1=reshape(tol1,N,M);
end

if converge=='n',
  disp('Integral did not converge--singularity likely')
end

if trace==1,
  plot(x_trace,y_trace,'+')
end


function [bp,wf]=grule(n)
%GRULE  computes base points and weight factors for a Gauss-
%       Legendre quadrature.
%
%CALL    [bp, wf]=grule(n);
% 
%   bp = base points
%   wf = weight factors
%   n  = number of base points (integrates a (2n-1)th order
%        polynomial exactly)
% 
%   The Gauss-Legendre quadrature integrates an integral of the form
%        1                 n
%       Int (f(x)) dx  =  Sum  wf_j*f(bp_j)
%       -1                j=1
%   See also: quadg.

%Reference
% Davis and Rabinowitz in 'Methods of Numerical Integration', page 365,
% Academic Press, 1975.

% Revised GKS 5 June 92
% Revised Per A. Brodtkorb pab@marin.ntnu.no 30.03.1999

% [bp,wf]=grule(n)
%  This function computes Gauss base points and weight factors
%  using the algorithm given by Davis and Rabinowitz in 'Methods
%  of Numerical Integration', page 365, Academic Press, 1975.
bp=zeros(n,1); wf=bp; iter=2; m=fix((n+1)/2); e1=n*(n+1);
mm=4*m-1; t=(pi/(4*n+2))*(3:4:mm); nn=(1-(1-1/n)/(8*n*n));
xo=nn*cos(t);
for j=1:iter
   pkm1=1; pk=xo;
   for k=2:n
      t1=xo.*pk; pkp1=t1-pkm1-(t1-pkm1)/k+t1;
      pkm1=pk; pk=pkp1;
   end
   den=1.-xo.*xo; d1=n*(pkm1-xo.*pk); dpn=d1./den;
   d2pn=(2.*xo.*dpn-e1.*pk)./den;
   d3pn=(4*xo.*d2pn+(2-e1).*dpn)./den;
   d4pn=(6*xo.*d3pn+(6-e1).*d2pn)./den;
   u=pk./dpn; v=d2pn./dpn;
   h=-u.*(1+(.5*u).*(v+u.*(v.*v-u.*d3pn./(3*dpn))));
   p=pk+h.*(dpn+(.5*h).*(d2pn+(h/3).*(d3pn+.25*h.*d4pn)));
   dp=dpn+h.*(d2pn+(.5*h).*(d3pn+h.*d4pn/3));
   h=h-p./dp; xo=xo+h;
end
bp=-xo-h;
fx=d1-h.*e1.*(pk+(h/2).*(dpn+(h/3).*(...
    d2pn+(h/4).*(d3pn+(.2*h).*d4pn))));
wf=2*(1-bp.^2)./(fx.*fx);
if (m+m) > n, bp(m)=0; end
if ~((m+m) == n), m=m-1; end
jj=1:m; n1j=(n+1-jj); bp(n1j)=-bp(jj); wf(n1j)=wf(jj);
% end
