function y = quadcc(fun,a,b,tol)
%QUADCC   Numerical integration using Clenshaw-Curtis quadrature.
%   Y = QUADCC(FUN,A,B) estimates the definite integral of the
%   function FUN from A to B, using an adaptive Clenshaw-Curtis 
%   quadrature scheme.  FUN is either a MATLAB expression written 
%   as a string or inline function, or a function M-file.  A and
%   B are the lower and upper limits of integration, respectively.
%
%   QUADCC computes the integral by recursively dividing the interval
%   (A,B) into finer subintervals, defined by the zero-points of the
%   Type 1 Chebyshev polynomials.  The recursion continues until 
%   either (1) the difference between computed estimates of the 
%   integral in successive recursion steps falls below a tolerance 
%   (default TOL = 1e-6), or (2) the integral domain has been 
%   divided into 1024 subintervals.  A warning is returned if the 
%   maximum number of subintervals is reached before the tolerance
%   criterion is met.
%   Y = QUADCC(FUN,A,B,TOL) uses the supplied value of TOL instead
%   of the default.
%
%   QUADCC provides limited handling of certain types of improper
%   integral.  If the integrand has a pole at one (or both) of the
%   integration limits, QUADCC returns a warning and attempts to
%   evaluate the integral by shifting the integration limit a 
%   distance EPS inside the integration interval.  If QUADCC
%   encounters a pole inside the integration interval, an error is
%   produced.
%
%   Examples:
%
%       1) String expression
%            Y = quadcc('1./(x.^2-5)',-1,2)
%
%       2) Inline function
%            foo = inline('x.*sin(x)')
%            Y = quadcc(foo,0,2*pi)
%
%       3) Function M-file
%            Y = quadcc(@foo,0,1)
%            with foo.m a function M-file:
%
%            function y = foo(x)
%            y = tan(x);
%
%   See also  QUAD, QUADL, DBLQUAD, TRIPLEQUAD, INLINE

%   References
%   ----------
%   "Numerical Recipes in C. The Art of Scientific Computing, 2nd edition".
%   W. H. Press, S. A. Teukolsky, W. T. Vetterling, and B. P. Flannery.
%   Cambridge Unversity Press, 2002.

% Paul Fricker  12/09/2002

if a==b
    y = 0;
    return
end

if ~exist('tol')
    tol = 1e-6;
end

% Make sure 'fun' is an inline function
f = fcnchk(fun);

% Initialize by breaking the integration interval into four regions.
N = 4;
p = (b+a)/2;
q = (b-a)/2;
% Write out [ cos((0:4)/4*pi) ] explicitly to avoid cos(pi/2) roundoff
x = p-q*[1 0.7071067811865475 0 -0.7071067811865475 -1];
F = feval(f,x);

% Simple attempt to handle improper integral
if isinf(F(1))
    F(1) = feval(f,x(1)+eps);
    warning('QUADCC:improperLower', ...
            ['Improper integral: Integrand has pole ' ...
             'at lower integration limit.'])
end

if isinf(F(5))
    F(5) = feval(f,x(5)-eps);
    warning('QUADCC:improperUpper', ...
            ['Improper integral: Integrand has pole ' ...
             'at upper integration limit.'])
end

% Modify the first and last terms of 'F'.
F(1) = F(1)/2;
F(end) = F(end)/2;

% Call the integrator function recursively
[y,warn] = intcc(f,x,F,N,p,q,tol,Inf);

if warn==1
    warning('QUADCC:MaxSubDivide', ...
            ['Computation terminated before tolerance criterion (TOL = ' num2str(tol) ') was met.'])
end


% EOF 'quadcc'


function [y,warn] = intcc(f,x,F,N,p,q,tol,yinit)
% INTCC Recursive integrator function for the QUADCC routine.
%
% Input parameters:
% f     : Integrand
% x     : Chebyshev polynomial zero-points between the integration limits (a,b)
% F     : Values of 'f' evaluated at 'x'
% N     : Initial number of zero-points ('discretization')
% p,q   : Endpoint parameters (from integration limits)
% tol   : Integration tolerance (terminates the recursion)
% yinit : Estimated value of the integral from the previous pass

% Terminate recursion if integral has not converged before 1024 points
if size(x,2) > 2^10
    warn = 1;
    y = yinit;
    return
else
    warn = 0;
end

% Double the size of the approximation
N = 2*N;
Nvec = 0:N;

x2 = zeros(1,N+1);
x2(1:2:end) = x;
x2(2:2:end) = p-q*cos((1:2:N)/N*pi);

G = zeros(1,N+1);
G(1:2:end) = F;
G(2:2:end) = feval(f,x2(2:2:end));
G = G(:);

if any(isinf(G))
    error('Improper integral: Integrand has a pole between integration limits.')
end

% Evaluate the Chebyshev polynomial coefficients for
% approximating the input function 'f'
M = cos(Nvec(1:2:end-1)'*Nvec/N*pi);
M(abs(M)<eps) = 0;
C = 4/N*M*G;

% Compute the quadrature coefficients
coeffs = -1./Nvec(2:2:end)./(Nvec(2:2:end)-2);
coeffs(1) = 0.5;

% Compute the integral estimate
y = q*coeffs*C;

% Continue recursion if the difference between the current value
% of the integral and the previous value is still above 'tol'.
if abs(y-yinit) > tol
    [y,warn] = intcc(f,x2,G,N,p,q,tol,y);
end

% EOF 'intcc'
