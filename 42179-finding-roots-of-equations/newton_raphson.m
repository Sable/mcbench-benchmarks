% Friday June 07 by Ehsan Behnam.
% b) Newton's method implemented in MATLAB.
% INPUT:1) "fx" is the equation string of the interest. The user 
% may input any string but it should be constructable as a "sym" object. 
% 2) x0 is the initial point.
% 3) intrvl is the interval of interest to find the roots.
% returns "rt" a vector containing all of the roots for eq = 0
% on the given interval.
%
function [rt iter_arr] = newton_raphson(fx, x, intrvl)
n_seeds = 10; %number of initial guesses!
x0 = linspace(intrvl(1), intrvl(2), n_seeds);
rt = zeros(1, n_seeds);

% An array that keeps the number of required iterations.
iter_arr = zeros(1, n_seeds);
n_rt = 0;

% Since sometimes we may not converge "max_iter" is set.
max_iter = 100;

% A threshold for distinguishing roots coming from different seeds. 
thresh = 0.001;

for i = 1:length(x0)
    iter = 0;
    eq = sym(fx);
    max_error = 10^(-12);
    df = diff(eq);
    err = Inf;
    x_this = x0(i);
    while (abs(err) > max_error)
        iter = iter + 1;
        x_prev = x_this;
        
        % Iterative process for solving the equation.
        x_this = x_prev - subs(fx, x, x_prev) / subs(df, x, x_prev);
        err = subs(fx, x, x_this);
        if (iter >= max_iter)
            break;
        end
    end
    if (abs(err) < max_error)
        % Many guesses will result in the same root.
        % So we check if the found root is new
        isNew = true;
        if (x_this >= intrvl(1) && x_this <= intrvl(2))
            for j = 1:n_rt
                if (abs(x_this - rt(j)) < thresh)
                    isNew = false;
                    break;
                end
            end
            if (isNew)
                n_rt = n_rt + 1;
                rt(n_rt) = x_this;
                iter_arr(n_rt) = iter;
            end
        end
    end        
end
rt(n_rt + 1:end) = [];
iter_arr(n_rt + 1:end) = [];