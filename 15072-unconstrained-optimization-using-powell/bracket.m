function [x1,x2,nS]=bracket(S,x0,d,problem,stepsize)
%   Bracket the minimum (or maximum) of the objective function
%   in the search direction.
%
%   [x1,x2,nS]=bracket(S,x0,d,problem,stepsize)
%
%   S: objective function
%   x0: initial point
%   d: search direction vector
%   problem: (-1): minimum (default), (1): maximum
%   stepsize: initial stepsize (default = 0.01*norm(d))
%   [x1,x2]: unsorted lower and upper limits
%   nS: number of objective function evaluations

%   Copyright (c) 2001 by LASIM-DEQUI-UFRGS
%   $Revision: 1.0 $  $Date: 2001/07/04 21:45:10 $
%   Argimiro R. Secchi (arge@enq.ufrgs.br)

 if nargin < 3,
   error('bracket requires three input arguments');
 end
 if nargin < 4,
   problem=-1;
 end
 if nargin < 5,
   stepsize=0.01*norm(d);
 end

 d=d(:);
 x0=x0(:);
 j=0; nS=1;
 y0=feval(S,x0)*problem;
 
 while j < 2,
  x=x0+stepsize*d;
  y=feval(S,x)*problem;
  nS=nS+1;
  
  if y0 >= y,
    stepsize=-stepsize;
    j=j+1;
  else
    while y0 < y,
      stepsize=2*stepsize;
      y0=y;
      x=x+stepsize*d;
      y=feval(S,x)*problem;
      nS=nS+1;
    end  
    j=1;
    break;
  end
 end
 
 x2=x;
 x1=x0+stepsize*(j-1)*d;
