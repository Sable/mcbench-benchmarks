function varargout = recur(f, varargin)

% varargout = recur(f, varargin)
% 
% See functional_programming_examples.m for a derivation of this function.
% 
% This function may take a moment to get used to. It allows an anonymous
% function to be recursive. This is "normally" not allowed, because an
% anonymous function has no name and therefore has no way of calling
% itself. This can be overcome, however, by writing the recursive anonymous
% function to accept both its normal inputs *and* a function handle. It can
% then call the function handle for recursion.
%
% Consider the Fibonacci sequence, F(n) = F(n-1) + F(n-2). If we were to
% write an anonymous function to this effect, it might like like this:
%
% fib = @(n) fib(n-1) + fib(n-2)
% 
% But that doesn't work! The 'fib' function isn't defined yet, so we can't
% call it. Now imagine that we wrote it this way:
%
% fib = @(f, n) f(f, n-1) + f(f, n-2)
%
% Now, if we passed '@fib' to 'fib' (along with 'n'), it will call itself
% correctly! This function simply passes a handle to the input function to
% the input function, along with any further arguments. We're not quite
% done with Fibonacci though. It requires a stopping condition so that it
% doesn't loop forever. We'll use the 'tern' function for that. Here's out
% complete Fibonacci sequence in a single anonymous function.
%
% >> fib = @(n) recur(@(f, n) tern(n <= 2, 1, @() f(f, n-1)+f(f, n-2)), n);
% >> fib(5)
% ans =
%      5
% >> arrayfun(fib, 1:10)
% ans =
%      1     1     2     3     5     8    13    21    34    55
%
% Tucker McClure
% Copyright 2013 The MathWorks, Inc.
     
    [varargout{1:nargout}] = f(f, varargin{:});

end
