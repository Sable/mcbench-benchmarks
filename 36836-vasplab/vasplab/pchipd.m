function pp = pchipd(x,y,d,xx)
%PCHIPD  Piecewise Cubic Hermite Interpolating Polynomial with Derivatives.
%   PP = PCHIPD(X,Y,D) provides the piecewise cubic polynomial which
%   interpolates values Y and derivatives D at the sites X.  This is meant
%   to augment the built-in Matlab function PCHIP, which does not allow the
%   user to specify derivatives.
%  
%   X must be a vector.
%
%   If Y and D are vectors, then Y(i) and D(i) are the value and derivative
%   to be matched at X(i).
%
%   If Y and D are matrices, then size(Y,2) == size(D,2) == length(X).
%   Also, size(Y,1) == size(D,1).  Use this for interpolating vector valued
%   functions.
%
%   YY = PCHIPD(X,Y,D,XX) is the same as YY = PPVAL(PCHIPD(X,Y,D),XX), thus
%   providing, in YY, the values of the interpolant at XX.
%
%   Example comparing SPLINE, PCHIP, and PCHIPD
%     a = -10;
%     b = 10;
%     x = linspace(a,b,7); 
%     f = @(x) 1./(1+exp(-x));  % logistic function
%     df = @(x) f(x).*(1-f(x)); % derivative of the logistic function
%     t = linspace(a,b,50);
%     r = f(t);
%     p = pchip(x,f(x),t);
%     s = spline(x,f(x),t);
%     q = pchipd(x,f(x),df(x),t);
%     plot(t,r,'k',x,f(x),'o',t,p,'-',t,s,'-.',t,q,'--')
%     legend('true','data','pchip','spline','pchipd',4)
%
%   See also INTERP1, SPLINE, PCHIP, PPVAL, MKPP, UNMKPP.
%

%
% 2010-10-04 (nwh) first version
%

% check inputs
% x must be a vector
if ~isvector(x)
  error('pchipd:input_error','x must be a vector of length > 2.')
end

% get size and orient
n = length(x);
x = x(:);

% make sure x is long enough, we can't construct an interpolating
% polynomial with just one point
if n < 2
  error('pchipd:input_error','x must be a vector of length > 2.')
end

% check y and d
if isvector(y) && isvector(d) && length(y) == n && length(d) == n
  % orient
  y = y(:);
  d = d(:);
  m = 1;
elseif size(y,2) == n && size(d,2) == n && size(y,1) == size(d,1)
  m = size(y,1);
  y = y';
  d = d';
else
  error('pchipd:input_error','y and d must be vectors or matrices of same size with length(x) columns.')
end

% sort breaks & data if needed
if ~issorted(x)
  [x x_ix] = sort(x);
  if m == 1
    y = y(x_ix);
    d = d(x_ix);
  else
    y = y(x_ix,:);
    d = d(x_ix,:);
  end
end

% compute coefficients
coef = zeros(m,n-1,4);
dx = diff(x);
for i = 1:m
  dy = diff(y(:,i));
  coef(i,:,4) = y(1:end-1,i)';
  coef(i,:,3) = d(1:end-1,i)';
  coef(i,:,2) = 3*dy./(dx.^2) - (2*d(1:end-1,i)+d(2:end,i))./dx;
  coef(i,:,1) = -2*dy./(dx.^3) + (d(1:end-1,i)+d(2:end,i))./(dx.^2);
end

% create the piecewise polynomial structure
pp = mkpp(x,coef,m);

% if user requests evaluations
if nargin > 3
  pp = ppval(pp,xx);
end