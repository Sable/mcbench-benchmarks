% A quick alternative to MATLAB's randperm

function p = randpermquick(n)
    p = 1:n;
    r = rand(1, n);
    randpermquick_helper(p, r);
end