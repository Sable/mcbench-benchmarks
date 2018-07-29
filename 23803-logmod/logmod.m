function y = logmod(x, a, p, N)

% Suppose:
%     p is an odd prime
%     a generates the units modulo p,
%     x is a unit modulo p
%     N is an integer >= 2.
% Then:
%    y = logmod(x, a, p, N)
%    returns  y such that a^y = x (mod p^N).
% Example:
% y = logmod(vpi(154), vpi(7), vpi(17), vpi(37))
% returns y = 2088349219044680767324467844670001776975183904
% where powermod(a, y, power(p,N)) == x

y = vpi(0);

% precondition testing
% ----------------------------------------------------------
if iseven(p) || ~isprime(p)
    disp('ERROR: p needs to be an odd prime number');
    return
end

if ~isunit(gcd(x,p))
    disp('ERROR: x and p must be relatively prime');
    return
end

if ~isunit(gcd(a,p))
    disp('ERROR: a does not generate the units modulo p');
    return
end

% verify that a generates the units modulo p and
% find y0 such that a^y0 = x (mod p).
target = vpi(1);
ix = vpi(1);
tmp = mod(a,p);
xm = mod(x,p);
y0 = vpi(0);
while (tmp ~= target) && (ix < (p-1))
    if tmp == xm
        y0 = ix;
    end
    ix = ix+1;
    tmp = mod(tmp*a,p);
end

if ix < (p-1)
    disp('ERROR: a does not generate the units modulo p');
    return
end

if N < 2
    disp('ERROR: N must be an integer >= 2');
    return
end

% -------------------------------------------------------------

tmp = vpi(1);
z = vpi(p);

P = [z];
while tmp < rdivide(N,2),
    tmp = 2*tmp;
    z = z*z;
    P = [P z];
end
P = [P p^N];

phi = [];
for z = P;
    phi = [phi, z - rdivide(z,p)];
end

y = y0;

for i=2:length(P)
    alpha = powermod(a, phi(i-1), P(i));
    alpha = mrdivide(alpha - 1, P(i-1));
    
    beta = powermod(a, y, P(i));
    beta = mrdivide(beta - x, P(i-1));
    
    n = minv(x*alpha, P(i));
    n = mod(-beta*n, P(i));
    
    y = mod(n*phi(i-1) + y, phi(i));
end
