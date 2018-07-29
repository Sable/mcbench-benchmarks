function x = zerobess(funstr,nu,m)
%ZEROBESS Zeros of Bessel functions/derivatives of 1st and 2nd kind.
%   X = ZEROBESS('J',NU,M) finds M positive zeros of the Bessel function
%   of the 1st kind, J_nu(X). The order NU is a real number in the range
%   0 to 1e7. Default is NU = 0 and M = 5.
%
%   ZEROBESS('Y',NU,M) - Zeros of the Bessel function the 2nd kind, Y_nu.
%   ZEROBESS('DJ',NU,M) - Zeros of the derivative of J_nu.
%   ZEROBESS('DY',NU,M) - Zeros of the derivative of Y_nu.
%
%   Examples
%       zerobess('J')
%       zerobess('Y',pi,10)
%       zerobess('DJ',1e-6)
%       zerobess('DY',1e6)
%       tic, x = zerobess('J',25,1e4); toc
%
%   See also BESSELJ, BESSELY

%   2010-02-10  Original ZEROBESS.
%   2010-11-09  Zeros of derivatives added.
%   2011-06-22  Cosmetic changes.
%   2011-12-02  More accurate for zerobess('DJ',nu,1), nu < 0.005.

%   Author: Jonas Lundgren <splinefit@gmail.com> 2010

if nargin < 1 || isempty(funstr), funstr = 'J'; end
if nargin < 2 || isempty(nu), nu = 0; end
if nargin < 3 || isempty(m), m = 5; end

% Check FUNSTR
if ~ischar(funstr)
    message = 'Function name FUNSTR must be a string.';
    error('ZEROBESS:NoString',message)
else
    funstr = upper(funstr);
end

% Check NU
if numel(nu) ~= 1 || ~isfinite(nu) || ~isreal(nu) || nu < 0 || nu > 1e7
    message = 'Order NU must be a real number between 0 and 1e7.';
    error('ZEROBESS:InvalidNU',message)
end

% Check M
if numel(m) ~= 1 || ~isfinite(m) || ~isreal(m) || m < 1 || fix(m) < m
    message = 'M must be a positive integer.';
    error('ZEROBESS:InvalidM',message)
end

% Set function handle and coefficients
switch funstr
    case 'J'
        fun = @besselj;
        deriv = 0;
        c0 = [  0.1701 -0.6563  1.0355  1.8558
                0.1608 -1.0189  3.1348  3.2447
               -0.2005 -1.2542  5.7249  4.3817 ];
    case 'Y'
        fun = @bessely;
        deriv = 0;
        c0 = [ -0.0474 -0.2300  0.2409  0.9316
                0.2329 -0.8871  2.0165  2.5963
                0.0013 -1.1220  4.3729  3.8342 ];
    case 'DJ'
        fun = @besselj;
        deriv = 1;
        c0 = [ -0.3601 -0.0233  0.0247  0.8087
                0.2232 -0.9275  1.9605  2.5781
                0.0543 -1.2050  4.3450  3.8258 ];
    case 'DY'
        fun = @bessely;
        deriv = 1;
        c0 = [  0.0116 -0.5561  0.9224  1.8212
                0.1766 -1.0713  3.0923  3.2329
               -0.1650 -1.3116  5.6956  4.3752 ];
    otherwise
        message = '''%s'' is not a valid bessel function.';
        error('ZEROBESS:InvalidName',message,funstr)
end

% Initiate zeros
x = zeros(m,1);

% Initial guess for the first three zeros
x0 = nu + c0*(nu+1).^[-1 -2/3 -1/3 1/3]';

% Exceptional case
n = 0;
if strcmp(funstr,'DJ') && nu < 0.8
    % Correction of initial guess
    d0 = [2, 3/2, -1/6, 53/576, -2059/34560, 86183/2073600];
    x0(1) = sqrt(d0*nu.^(1:6)');
    if nu < 0.005
        % Skip Newton-Raphson and use asymptotic value
        x(1) = x0(1);
        n = 1;
    end
end

% Newton-Raphson iterations
x(n+1:3) = newton(fun,deriv,nu,x0(n+1:3));

n = 3;  % Number of zeros computed
j = 2;  % Number of zeros to compute next
errtol = 0.005;  % Relative error tolerance for initial guess

% Remaining zeros
while n < m
    
    % Upper bound for j
    j = min(j,m-n);
    
    % Predict the spacing dx between zeros
    r = diff(x(n-2:n)) - pi;
    if r(1)*r(2) > 0 && r(1)/r(2) > 1
        p = log(r(1)/r(2))/log(1-1/(n-1));
        dx = pi + r(2)*exp(p*log(1+(1:j)/(n-1)))';
    else
        dx = repmat(pi,j,1);
    end

    % Initial guess for zeros
    x0 = x(n) + cumsum(dx);

    % Newton-Raphson iterations
    x(n+1:n+j) = newton(fun,deriv,nu,x0);
    n = n + j;
 
    % Check zeros
    if ~chkzeros(nu,x(n-j-1:n),deriv)
        message = 'Bad zeros encountered. NU and/or M may be too large.';
        error('ZEROBESS:BadZeros',message)
    end
    
    % Relative error
    err = (x(n-j+1:n) - x0)./diff(x(n-j:n));

    % Number of zeros to compute next
    if max(abs(err)) < errtol
        j = 2*j;
    else
        j = 2*find(abs(err) >= errtol,1);
    end
    
end

% Return
x = x(1:m);


%--------------------------------------------------------------------------
function x = newton(fun,deriv,nu,x0)
% Newton-Raphson for Bessel function FUN or FUN' with initial guess X0
x = x0;
c = 8;
for t = 1:10
    % Newton-Raphson step
    f = fun(nu,x);
    g = nu*f./x;
    df = fun(nu-1,x) - g;
    if deriv == 0
        h = -f./df;
    else
        ddf = (nu*g - df)./x - f;
        h = -df./ddf;
    end
    x = x + h;
    % Convergence criteria
    if all(abs(h) < c*eps(x))
        break
    end
    % Relax convergence criteria
    if t >= 7
        c = 2*c;
    end
end
% Check convergence
if t == 10
    warning('ZEROBESS:Newton','No convergence for Newton-Raphson.')
end
% fprintf('%2d%8d\n',t,numel(x))


%--------------------------------------------------------------------------
function s = chkzeros(nu,x,deriv)
% Check sequence of Bessel function zeros
dx = diff(x);
% The spacing dx should decrease except for nu < 0.5
ddx = diff(dx);
if nu < 0.5 && deriv == 0
    ddx = -ddx;
end
% Criteria for acceptable zeros
s = isreal(x) && x(1) > 0 && all(dx > 3) && all(ddx < 16*eps(x(2:end-1)));

