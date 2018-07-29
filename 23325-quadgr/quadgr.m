function [Q,err] = quadgr(fun,a,b,tol,trace,varargin)
%QUADGR Gauss-Legendre quadrature with Richardson extrapolation.
%   [Q,ERR] = QUADGR(FUN,A,B,TOL) approximates the integral of a function
%   FUN from A to B with an absolute error tolerance TOL. FUN is a function
%   handle and must accept vector arguments. TOL is 1e-6 by default. Q is
%   the integral approximation and ERR is an estimate of the absolute error.
%
%   QUADGR uses a 12-point Gauss-Legendre quadrature. The error estimate is
%   based on successive interval bisection. Richardson extrapolation
%   accelerates the convergence for some integrals, especially integrals
%   with endpoint singularities.
%
%   QUADGR(FUN,A,B,TOL,TRACE) with non-zero TRACE displays the
%   extrapolation table.
%
%   QUADGR can also be used as the quadrature in DBLQUAD and TRIPLEQUAD.
%
%   Examples:
%     Q = quadgr(@(x) log(x),0,1)
%     [Q,err] = quadgr(@(x) exp(x),0,9999i*pi)
%     [Q,err] = quadgr(@(x) sqrt(4-x.^2),0,2,1e-12)
%     [Q,err] = quadgr(@(x) x.^-0.75,0,1)
%     [Q,err] = quadgr(@(x) 1./sqrt(1-x.^2),-1,1)
%     [Q,err] = quadgr(@(x) exp(-x.^2),-inf,inf,1e-9) % sqrt(pi)
%     [Q,err] = quadgr(@(x) cos(x).*exp(-x),0,inf,1e-9)
%
%   See also QUAD, QUADGK, DBLQUAD, TRIPLEQUAD

%   Author: Jonas Lundgren <splinefit@gmail.com> 2009

%   2009-03-17  First published
%   2010-04-14  Adapted to DBLQUAD and TRIPLEQUAD (varargin added)

if nargin < 3, help quadgr, return, end
if nargin < 4 || isempty(tol), tol = 1.e-6; end;
if nargin < 5 || isempty(trace), trace = 0; end;

% Order limits (required if infinite limits)
if a == b
    Q = b - a;
    err = b - a;
    return
elseif a > b
    reverse = true;
    atmp = a;
    a = b;
    b = atmp;
else
    reverse = false;
end

% Infinite limits
if isinf(a) || isinf(b)
    % Check real limits
    if ~isreal(a) || ~isreal(b) || isnan(a) || isnan(b)
        error('quadgr:inflim','Infinite intervals must be real.')
    end
    % Change of variable
    if isfinite(a) && isinf(b)
        % a to inf
        fun1 = @(t,varargin) fun(a + t./(1-t), varargin{:})./(1-t).^2;
        [Q,err] = quadgr(fun1,0,1,tol,trace,varargin{:});
    elseif isinf(a) && isfinite(b)
        % -inf to b
        fun2 = @(t,varargin) fun(b + t./(1+t), varargin{:})./(1+t).^2;
        [Q,err] = quadgr(fun2,-1,0,tol,trace,varargin{:});
    else % -inf to inf
        fun1 = @(t,varargin) fun(t./(1-t), varargin{:})./(1-t).^2;
        fun2 = @(t,varargin) fun(t./(1+t), varargin{:})./(1+t).^2;
        [Q1,err1] = quadgr(fun1,0,1,tol/2,trace,varargin{:});
        [Q2,err2] = quadgr(fun2,-1,0,tol/2,trace,varargin{:});
        Q = Q1 + Q2;
        err = err1 + err2;
    end
    % Reverse direction
    if reverse
        Q = -Q;
    end
    return 
end

% Gauss-Legendre quadrature (12-point)
xq = [0.12523340851146894; 0.36783149899818018; 0.58731795428661748; ...
      0.76990267419430469; 0.9041172563704748; 0.98156063424671924];
wq = [0.24914704581340288, 0.23349253653835478, 0.20316742672306584, ...
      0.16007832854334636, 0.10693932599531818, 0.047175336386511842];
xq = [xq; -xq];
wq = [wq, wq];
nq = length(xq);

% Initiate vectors
maxit = 17;                 % Max number of iterations
Q0 = zeros(maxit,1);       	% Quadrature
Q1 = zeros(maxit,1);       	% First Richardson extrapolation
Q2 = zeros(maxit,1);       	% Second Richardson extrapolation

% One interval
hh = (b - a)/2;             % Half interval length
x = (a + b)/2 + hh*xq;      % Nodes
% Quadrature
Q0(1) = hh*wq*fun(x,varargin{:});

% Successive bisection of intervals
for k = 2:maxit
    
    % Interval bisection
    hh = hh/2;
    x = [x + a; x + b]/2;
    % Quadrature
    Q0(k) = hh*wq*sum(reshape(fun(x,varargin{:}),nq,[]),2);
    
    % Richardson extrapolation
    if k >= 5
        Q1(k) = richardson(Q0,k);
        Q2(k) = richardson(Q1,k);
    elseif k >= 3
        Q1(k) = richardson(Q0,k);
    end
   
    % Estimate absolute error
    if k >= 6
        Qv = [Q0(k), Q1(k), Q2(k)];
        Qw = [Q0(k-1), Q1(k-1), Q2(k-1)];
    elseif k >= 4
        Qv = [Q0(k), Q1(k)];
        Qw = [Q0(k-1), Q1(k-1)];
    else
        Qv = Q0(k);
        Qw = Q0(k-1);
    end
    [err,j] = min(abs(Qv - Qw));
    Q = Qv(j);
    
    % Convergence
    if err < tol || ~isfinite(Q)
        break;
    end 
    
end

% Convergence check
if ~isfinite(Q)
    warning('quadgr:infnan','Integral approximation is Infinite or NaN.')
elseif err > tol
    warning('quadgr:maxiter','Max number of iterations reached without convergence.')
end

% The error estimate should not be zero
err = err + 2*eps(Q);
% Reverse direction
if reverse
	Q = -Q;
end

% Display convergence
if trace
    disp(' ')
    disp([Q0(1:k) Q1(1:k) Q2(1:k)])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function R = richardson(Q,k)
% Richardson extrapolation with parameter estimation
if Q(k) ~= Q(k-1)
    c = real((Q(k-1)-Q(k-2))/(Q(k)-Q(k-1))) - 1;
else
    c = 1;
end
% The lower bound 0.07 admits the singularity x.^-0.9
c = max(c,0.07);
R = Q(k) + (Q(k) - Q(k-1))/c;
