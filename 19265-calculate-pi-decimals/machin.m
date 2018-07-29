function s = machin(m)
%MACHIN Calculate decimals of pi with Machin's formula
%   MACHIN(M) gives a string with pi truncated to M decimals
%   using Machin's formula: pi = 16*acot(5) - 4*acot(239)
%
%   This is a faster but less readable version of MACHIN0.

%   Author: Jonas Lundgren <splinefit@gmail.com> 2011

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
t = floor(base/b);
u = base - b*t;
m = floor(n*log(base)/log(b));

% y = 0
y = zeros(n+1,1);

% y = c/(2*k+1) - y/b
for k = m:-1:0
    nn = ceil(n-n*k/m+1);
    bb = 2*k+1;
    tt = floor(base/bb);
    uu = base - bb*tt;
    vv = c;
    v = y(1);
    qq = floor(vv/bb);
    q = floor(v/b);
    y(1) = qq - q;
    for j = 2:nn
        rr = vv - bb*qq;
        r = v - b*q;
        vv = rr*uu;
        v = y(j) + r*u;
        qq = floor(vv/bb);
        q = floor(v/b);
        y(j) = qq + rr*tt - q - r*t;
    end
end

% y = y/a
r = 0;
t = floor(base/a);
u = base - a*t;
for k = 1:n+1
	v = y(k) + r*u;
	q = floor(v/a);
	y(k) = q + r*t;
	r = v - a*q;
end

