
% Fibonacci.m by David Terr, Raytheon, 5-11-04

% Given an integers n, compute the nth Fibonacci number.

function fib = Fibonacci(n)

% Make sure input is an integer.
if ( n ~= floor(n) )
    error('Argument must be an integer.');
    return;
end

if ~isreal(n)
    error('Argument must be an integer.');
    return;
end

if size(n,1) ~= 1 || size(n,2) ~= 1
    error('Argument must be an integer.');
    return;
end

if ( n == 0 )
    fib = 0;
    return;
end

if ( n < 0 )
    fib = (-1)^(n+1) * Fibonacci(-n);
    return;
end

alpha = (1 + sqrt(5))/2;
fib = round( alpha^n / sqrt(5) );

