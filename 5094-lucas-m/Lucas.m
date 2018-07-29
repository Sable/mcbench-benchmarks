
% Fibonacci.m by David Terr, Raytheon, 5-11-04

% Given an integers n, compute the nth Lucas number.

function luc = Lucas(n)

% Make sure input is an integer.
if n ~= floor(n)
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
    luc = 2;
    return;
end

if ( n == 1 )
    luc = 1;
    return;
end

if ( n < 0 )
    luc = (-1)^n * Lucas(-n);
    return;
end

alpha = (1 + sqrt(5))/2;
luc = round( alpha^n );
return;

