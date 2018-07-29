function x = forloop(x, n, f, cleanup_fcn)

% x = forloop(x, n, f, cleanup_fcn)
% 
% Loop a given number of times. f should be a function handle taking in
% x and k, the iteration number (which starts at 1), and returning the
% updated x. If x is a cell array, each cell is handed to f as in
% f(x{:}), which allows f to have the form @(x1, x2,..., k).
%
% forloop(1,                        % Start with x = 1.
%         9,                        % Loop 9 times.
%         @(x, k) last(fprintf('Factorial(%d): %d\n', k, k*x), ...
%                      k*x))        % Print the result and return k*x.
%
% Tucker McClure
% Copyright 2013 The MathWorks, Inc.

    for k = 1:n
        if iscell(x)
            x = f(x{:}, k);
        else
            x = f(x, k);
        end
    end
    
    if nargin == 4
        if iscell(x)
            x = cleanup_fcn(x{:});
        else
            x = cleanup_fcn(x);
        end
    end

end