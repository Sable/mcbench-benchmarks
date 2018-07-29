function [df d_arr] = richardson_based_derivative(eq, x0, n, h)
% July 1, 2013 by Ehsan Behnam.
% [df d_arr] = richardson_based_derivative(...) 
% computes the derative of the equation "eq" % at "x0" 
% using "n" iterations of Richardson extrapolation.
% "h" specifies the initial differential increment/decrement around x0
% (i.e. f(x+h) or f(x-h)). 
% A couple of notes: 
% 1) "eq" can be any string in the form of f(x). Note that it should be 
% computable in Matlab so for example, use eq = 'exp(x)' instead of 'e^x'.
% 2) No matter of what is "h" at each step h <- h/2. Therefore if you want
% to compare the accuracy of this method to other methods (e.g. Tyler's
% series), you need to adjust the number of required steps properly. 

% The first output "df" is the d(eq(x))/dx |@(x = x0). Regarding the 
% educational purposes for producing the whole table, the function also 
% outputs the whole array iteratively generated as the function progresses.

% Basic usage example: 
% eq = 'x^3*exp(-x)';
% df = richardson_based_derivative(eq, 0.1, 10);
% Finding the difference between "df" and the Matlab output ...
% disp(subs(diff(sym(eq)), 0.1) - df);
% It will show "-4.6263e-07" on the workspace.

if (nargin < 2 || nargin > 4)
    help('richardson_based_derivative');
    df = '';
    d_arr = '';
    return;
end

if (nargin == 2)
    h = 1/2;
    n = 5;
end

if (nargin == 3)
    h = 1/2;
end

fx = sym(eq);

%Initialization:
d_arr = zeros(n);
for i = 1:n
    d_arr(i, 1) = subs(fx, 'x', x0 + h) - subs(fx, 'x', x0 - h);
    d_arr(i, 1) = d_arr(i, 1) / (2 * h);
    % Iteratively computing the coefficients:
    for j = 2:i
        d_arr(i, j) = d_arr(i, j - 1) + (d_arr(i, j - 1) - ...
                      d_arr(i - 1, j - 1)) / (4 ^j -1);
    end
    % next iteration "h":
    h = h/2;
end
df = d_arr(end, end);