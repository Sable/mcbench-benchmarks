function [ a, b, k ] = bisection(f, a, b, N, Tol, verb)
%
% bisection(f, a, b, N, Tol)
%
% BISECTION
%   Bisection Method.
%
% Input:
%   f - function given as a string
%   a - lower bound
%   b - upper bound
%   N - number of iterations
%   Tol - error tolerance
%   verb - verbose mode
%
% Output:
%   a - lower bound
%   b - upper bound
%   k - number of iterations performed
%
% Examples:
%   [ a, b, k ] = bisection( '1/x', -1, 1, 1e2, 1e-5, true )
%   [ a, b, k ] = bisection( '1/x', -1, 1, 1e2, 1e-5, 1 )
%   [ a, b, k ] = bisection( 'abs(log(x))-0.2*sin(x)', 1, pi/2 )
%   [ a, b, k ] = bisection( 'abs(log(x))-0.2*sin(x)', .5, 1, 1e2, 1e-5 )
%
% Author:	Tashi Ravach
% Version:	1.0
% Date:     03/04/2006
%

    if nargin == 3
        N = 1e4;
        Tol = 1e-4;
        verb = false;
    elseif nargin == 4
        Tol = 1e-4;
        verb = false;
    elseif nargin == 5
        verb = false;
    elseif nargin ~= 6
        error('bisection: invalid input parameterss');
    end
    
    f = inline(f);
    if (f(a) * f(b) > 0) || (a >= b)
        error('bisection: condition f(a)*f(b)>0 or a>=b didn''t apply');
    end
    
    k = 1;
    x(k) = (a + b) / 2;
    if verb == true
        fprintf('\na = %d\nb = %d\nx(%d) = %d\n', a, b, k, x(k));
    end
    while ((k <= N) && ((b - a) / 2) >= Tol)
        if f(x(k)) == 0
            error([ 'bisection: condition f(' num2str(x(k)) ...
                ')~=0 didn''t apply' ]);
        end
        if (f(x(k)) * f(a)) < 0
            b = x(k);
        else
            a = x(k);
        end
        k = k + 1;
        x(k) = (a + b) / 2;
        if verb == true
            fprintf('\na = %d\nb = %d\nx(%d) = %d\n', a, b, k, x(k));
        end
    end
    
end