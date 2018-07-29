function [x,param,values] = coarserefine(f,intrv,theta,N,alpha)
% 1-D adaptive residual subsampling method for radial basis function 
% interpolation
%
% f: function defined on interval intrv = [a b].
% intrv: interval [a b] where f is defined.
% theta: threshold interval [thetar thetac] where thetac < thetar.
%        thetar: refinement threshold.
%        thetac: coarsening threshold.
% N: Initial equally-spaced N centers.
% alpha: global multiplier of multiquadric parameters
%
% Example 1 :  f = @(x) abs(x+.04)
%              coarserefine(f,[-1 1],[5e-5 5e-7],11,0.75)
%
% Example 2 :  coarserefine(@(x)myfun(x,5),[-1 1],[5e-5 5e-7],11,0.75)
%              %----------------------%
%              function y = myfun2(x,c)
%              y = 1./(1 + (c*x).^2);
%              %----------------------% 
% For reference, see:
% Adaptive residual subsampling methods for radial basis function
% interpolation and collocation problems. submitted to Computers Math. Appl
%
% Tobin A. Driscoll and Alfa R.H. Heryudono    05/14/2006
% MATLAB 7 is recommended.

% Initial points
x = linspace(intrv(1),intrv(2),N)';
N = length(x); dx = diff(x); 
epsilon = alpha*min([Inf;1./dx],[1./dx;Inf]);
y = x(1:N-1) + 0.5*dx;

refine = true;
while any(refine)
  A = zeros(N); B = zeros(N-1,N);
  for j=1:N
    A(:,j) = mq(x,x(j),epsilon(j));
    B(:,j) = mq(y,x(j),epsilon(j));
  end
  lambda = A\feval(f,x); 
  resid = abs(B*lambda - feval(f,y)); 
  
  refine = resid > theta(1);
  fprintf('Adding %i centers.',sum(refine))
  vals = sortrows([[x;y(refine)] [feval(f,x);B(refine,:)*lambda]]);
  x = vals(:,1); vals(:,1)=[];
  dx = diff(x); epsilon = alpha*min([Inf;1./dx],[1./dx;Inf]);
  
  coarsen = resid(1:N-2) < theta(2) & resid(2:N-1) < theta(2);
  coarsen = 1+find(coarsen); x(coarsen) = []; vals(coarsen) = []; epsilon(coarsen)=[];
  fprintf(' Removing %i centers.\n',length(coarsen))
  
  N = length(x);
  y = x(1:N-1) + 0.5*diff(x);
end

if nargout > 1
    param = epsilon;
    if nargout > 2
        values = vals;
    end
end