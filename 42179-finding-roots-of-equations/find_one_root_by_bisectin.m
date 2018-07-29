%Supplementary function to hw1_bisection method.
function [root conv_rate] = find_one_root_by_bisectin(eq, x, intrvl, ...
                            max_error, n_steps)
%We must have one root on the specified interval "intrvl".
mid = (intrvl(1) + intrvl(2)) / 2;
n_steps = n_steps + 1;

f_init = subs(eq, x, intrvl(1));

f_mid = subs(eq, x, mid);
if (abs(f_mid) < max_error)
    root = mid;
    conv_rate = n_steps;
    return;
end


%recursive call.
if (f_init * f_mid < 0)
    [root conv_rate] = find_one_root_by_bisectin(eq, x, ..., 
                       [intrvl(1) mid], max_error, n_steps);
else
    [root conv_rate] = find_one_root_by_bisectin(eq, x, ..., 
                       [mid intrvl(2)], max_error, n_steps);
end   