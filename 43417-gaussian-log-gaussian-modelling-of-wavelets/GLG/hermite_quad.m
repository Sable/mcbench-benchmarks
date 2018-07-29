function [X, W] = hermite_quad(N, max_it)

% Find the Gauss-Hermite abscissae and weights.
%
% The procedure is based on
% Press, Flannery, Teukolsky and Vetterling: Numerical Recipes in C++, 2
% edn, 2002
% and inspired by the implementation
% http://hips.seas.harvard.edu/content/gauss-hermite-quadrature-matlab
%
%
% Syntax:
%   [X, W] = hermite_quad(N, [max_it])
%
%
% Input:
%   N      : The number of quadrature points.
%
%   max_it : The maximum number of iterations in Newton-Raphson
%
%
% Output:
%   X      : A column vector containing the abscissae.
%
%   W      : A column vector containing the corresponding weights.
%

% precision
EPS = 3.0e-14;

% 1/\pi^{1/4}
PIM4 = 0.7511255444649425;

% maximum number of loops
if nargin == 1
    max_it = 10;
end

% allocate the return values
X = zeros([N 1]);
W = zeros([N 1]);

for i=1:(N+1)/2
    
    % Good guesses at initial values for specific roots
    switch i
        case 1
            z = sqrt(2.0*N+1.0) - 1.85575*((2.0*N+1)^(-0.16667));
            
        case 2
            z = z - (1.14 * N^0.426 / z);
            
        case 3
            z = 1.86 * z - 0.86 * X(1);
            
        case 4
            z = 1.91 * z - 0.91 * X(2);
            
        otherwise
                z = 2.0*z - X(i-2);
    end
    
    % Newton-Raphson
    for iter=1:max_it+1
        p1 = PIM4;
        p2 = 0.0;
        
        for j=1:N
            p3 = p2;
            p2 = p1;
            p1 = z * sqrt(2.0/j) * p2 - sqrt( (j - 1.0)/j ) * p3;
        end
        
        % The derivative
        pp = sqrt(2.0*N) * p2;
        
        % Newton-Raphson step
        z1 = z;
        z  = z1 - p1/pp;
        
        if abs(z - z1) <= EPS
            break;
        end
    end
    
    if iter == max_it+1
        fprintf('Too many iterations in hermite_quad.\n');
    end
    
    X(i)     = z;
    X(N+1-i) = -z;
    W( [i N+1-i] ) = 2.0/(pp*pp);
        
end
