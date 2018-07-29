function optimal = goldensection(f,a,b,uncertain)

% Program : goldensection.m
%
% Purpose : find the optimal point of a given single variable function 
%           within the given interval
%
% Author :  Aamir Alaud Din
% Date :    29.09.2013
%
% Inputs :  Four input arguments are required viz., function, initial and
%           final points of the interval, and level of uncertainty
%
% Syntax :  optimal = goldensection(f,a,b)
%           where f is an inline function 
%           e.g., f = inline('sin(x)','x');
%           a and b are initial and final points ofthe interval
%           respectively
%
% Example:  optimal = goldensection(f,-3,5)
%           Fourth input is the level of uncertainty input by the user.
%           Default is 0.001.
%
% Syntax:   optimal = goldensection(f,a,b, uncertain)
%           f, a, and b are described above. Uncertainty level is decided
%           by the user.
%
% Example:  optimal = goldensection(f,-3,5,1e-6)

rho = (3 - sqrt(5))/2;

if (nargin < 3)
    error('Too few input arguments for golden section search');
    optimal = 'Golden section search requires at least three inputs';
    return;
    
elseif (nargin == 3)
    if (a == b)
        error('same values of a and b do not make an interval');
        optimal = 'No interval given for optimization'
        return;
    end
    n = log(0.001/(b - a))/log(1 - rho);
    n = ceil(n);
    fprintf('Iteration   \t    a    \t\t    b    \t\t   f(a)   \t\t   f(b)\n');
    fprintf('=========   \t=========\t\t=========\t\t==========\t\t==========\n');
    for ii = 1:n
        a1 = a + rho * (b - a);
        b1 = a + (1 - rho) * (b - a);
        fprintf('%4d', ii);
        fprintf('%21.4f', a1);
        fprintf('%16.4f', b1);
        fprintf('%17.4f', f(a1));
        fprintf('%16.4f', f(b1));
        fprintf('\n');
        if (f(a1) < f(b1))
            b = b1;
        else
            a = a1;
        end
    end
    optimal = min(a,b);
    
elseif (nargin == 4)
    if (a == b)
        error('same values of a and b do not make an interval');
        optimal = 'No interval given for optimization'
        return;
    end
    n = log(uncertain/(b - a))/log(1 - rho);
    n = ceil(n);
    fprintf('Iteration   \t    a    \t\t    b    \t\t   f(a)   \t\t   f(b)\n');
    fprintf('=========   \t=========\t\t=========\t\t==========\t\t==========\n');
    for ii = 1:n
        a1 = a + rho * (b - a);
        b1 = a + (1 - rho) * (b - a);
        fprintf('%4d', ii);
        fprintf('%21.4f', a1);
        fprintf('%16.4f', b1);
        fprintf('%17.4f', f(a1));
        fprintf('%16.4f', f(b1));
        fprintf('\n');
        if (f(a1) < f(b1))
            b = b1;
        else
            a = a1;
        end
    end
    optimal = min(a,b);
    
elseif (nargin > 4)
    error('Too many input arguments for golden section search');
    optimal = 'Golden section search can''t procees with too many inputs';
    return;
    
end