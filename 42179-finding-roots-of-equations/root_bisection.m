% Friday June 07 by Ehsan Behnam.
% a) Bisection method implemented in MATLAB.
% INPUT:1) "fx" is the equation of the interest. The user 
% may input any string but it should be constructable as a "sym" object. 
% 2) x is the symbol used for inputing the equation. 
% 3) intrvl is the interval of interest to find the roots.
% returns "rt" a vector containing all of the roots for eq = 0
% on the given interval.
% Returns also the number of steps "n_steps" that is required to
% find the root having the max_error stated inside the function.
%
function [rt n_steps] = root_bisection(fx, x, intrvl)
eq = sym(fx);
max_error = 10^(-12);
%The reason for having this upper limit for the number
%of expected roots is that we want ALL of the roots 
%using the bisection method. The user may trade-off
%speed with accuracy by decreasing this limit.
n_roots_upper_limit = 20;
rt = zeros(1, n_roots_upper_limit);
n_steps = zeros(1, n_roots_upper_limit);
a = linspace(intrvl(1), intrvl(2), n_roots_upper_limit);
n_rt = 0;

%checking the very first point which is lower bound
%on the input interval.
if (subs(eq, x, a(1)) == 0)
    n_rt = n_rt + 1;
    rt(n_rt) = a(1);
end

%Stores the error in different steps of the function.
%Use this to see the convergence rate.
for i = 1:n_roots_upper_limit - 1
    steps = 0;
    if (subs(eq, x, a(i)) * subs(eq, x, a(i + 1)) < 0)
        n_rt = n_rt + 1;
        [rt(n_rt) n_steps(n_rt)] = find_one_root_by_bisectin(eq, x, ...
                         [a(i) a(i + 1)], max_error, steps);
                                                
    elseif (abs(subs(eq, x, a(i + 1))) == 0)
        n_rt = n_rt + 1;
        rt(n_rt) = a(i + 1);
    end
end
rt(n_rt + 1:end) = [];
n_steps(n_rt + 1:end) = [];