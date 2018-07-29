function x = loop(x, continue_fcn, f, cleanup_fcn)

% x = loop(x, continue_fcn, f, cleanup_fcn)
%
% Looping function. Provides the ability to treating "looping" as a
% function instead of a command.
%
% See functional_programming_examples.m for a discussion of this function.
% 
% Inputs:
% x            - Initial state (can be cell array of arguments to f)
% continue_fcn - Continue function, returns true iff the loop should go on
% f            - Function of the state (x) to run every iteration
% cleanup_fcn  - Function to select what to return from the state when the
%                looping is complete (optional)
%
% Outputs:
% x        - The updated state. If a cleanup function is supplied, this
%            will be cleanup(x).
%
% Fibonacci example:
%
% fib = @(n) loop({1, 0, 1}, ...          % {k, fib(k-1), fib(k)}
%                 @(x) x{1} < n, ...      % While k < n
%                 @(x) {x{1} + 1, ...     %   Increase k
%                       x{3}, ...         %   Store fib(k-1)
%                       x{3} + x{2}}, ... %   Store fib(k-1) + fib(k-2)
%                 @(x) x{3})              % End, returning only fib(k)
%                      
% arrayfun(fib, 1:10)
%
% Tucker McClure
% Copyright 2013 The MathWorks, Inc.

    while tern(iscell(x), @()continue_fcn(x{:}), @()continue_fcn(x))
        if iscell(x)
            x = f(x{:});
        else
            x = f(x);
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
