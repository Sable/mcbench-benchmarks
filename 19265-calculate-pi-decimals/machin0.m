function s = machin0(m)
%MACHIN Calculate decimals of pi with Machin's formula
%   MACHIN(M) gives a string with pi truncated to M decimals
%   using Machin's formula: pi = 16*acot(5) - 4*acot(239)

%   Author: Jonas Lundgren <splinefit@gmail.com> 2008

if nargin < 1, m = 50; end
base = 1e15;
n = ceil(m/15) + 1;

% Machin's formula
x = xacot(5,16,n,base) - xacot(239,4,n,base);

% Canonical form
carry = 0;
for k = n+1:-1:1
    xk = x(k) + carry;
    carry = floor(xk/base);
    x(k) = xk - carry*base;
end

% Write string
s = sprintf('%15.0f',x(2:n));
s(isspace(s)) = '0';
s = ['3.', s(1:m)];

%--------------------------------------------------------------------------
function y = xacot(a,c,n,base)
% Calculate C*ACOT(A) to N digits in base BASE

b = a*a;
m = floor(n*log(base)/log(b));

x = [c; zeros(n,1)];                            % x = c
y = 0;                                          % y = 0
for k = m:-1:0
	y = xdiv(x,2*k+1,base) - xdiv(y,b,base);	% y = c/(2*k+1) - y/b
end
y = xdiv(y,a,base);                             % y = y/a

%--------------------------------------------------------------------------
function x = xdiv(x,a,base)
% Calculate X/A to N digits in base BASE

r = 0;
t = floor(base/a);
u = base - a*t;
for k = 1:numel(x)
	v = x(k) + r*u;
	q = floor(v/a);
	x(k) = q + r*t;
	r = v - a*q;
end

