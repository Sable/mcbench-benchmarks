
% GeneralizedFibonacci.m by David Terr, Raytheon, 5-11-04

% Given integers n, a, and b, compute the nth generalized Fibonacci number
% U_n, defined by the recurrence U_n = a U_{n-1} + b U_{n-2} and the
% initial conditions U_0 = 0 and U_1 = 1.

function gfib = GeneralizedFibonacci(n,a,b)

% Make sure arguments are integers.
if ( n ~= floor(n) )
    error('First argument must be a nonnegative integer.');
    return;
end

if ~isreal(n) || n < 0
    error('First argument must be a nonnegative integer.');
    return;
end

if size(n,1) ~= 1 || size(n,2) ~= 1
    error('First argument must be a nonnegative integer.');
    return;
end

if ( a ~= floor(a) )
    error('Second argument must be an integer.');
    return;
end

if ~isreal(a)
    error('Second argument must be an integer.');
    return;
end

if size(a,1) ~= 1 || size(a,2) ~= 1
    error('Second argument must be an integer.');
    return;
end

if ( b ~= floor(b) )
    error('Third argument must be an integer.');
    return;
end

if ~isreal(b)
    error('Third argument must be an integer.');
    return;
end

if size(b,1) ~= 1 || size(b,2) ~= 1
    error('Third argument must be an integer.');
    return;
end

if ( n == 0 )
    gfib = 0;
    return;
end

D = a^2 + 4*b;  % discriminant

if ( D <= 0 )
    error('Discriminant must be positive.');
    return;
end

alpha = (a + sqrt(D))/2;
beta = (a - sqrt(D))/2;
gfib = round( ( alpha^n - beta^n ) / sqrt(D) );

