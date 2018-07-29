function x = dowhile(x, continue_fcn, f, cleanup_fcn)

% x = dowhile(x, cont, f, cleanup)
%
% Do-while loop behavior. This is the same as loop except that it always
% runs at least once. This is useful, e.g., when you want to do something
% again and again until it succeeds.
% 
% See functional_programming_examples.m for a discussion of |loop|.
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
%            will be cleanup(x) or cleanup(x{:}) if x is a cell array.
%
% Example:
% 
% % Create a function to draw n numbers from randn until a series of all
% % positive numbers is found. Since we don't start with a draw yet, this
% % makes sense as a dowhile instead of a loop.
% draw_until_all_positive = @(n) ...
%     dowhile([], ...               % No initial set of draws.
%             @(x) any(x <= 0), ... % Until we've drawn all positive set
%             @(x) randn(1, n));    %   Draw new set of n numbers.
%         
% % Drawing 4 positive numbers in a row happens frequently.
% tic()
% draw_until_all_positive(4)
% toc();
% 
% % Drawing 16 positive numbers in a row happens rarely. We can see this
% % function takes a lot more time to complete.
% tic()
% draw_until_all_positive(16)
% toc();
%
% Tucker McClure
% Copyright 2013 The MathWorks, Inc.

    while true
        if iscell(x)
            x = f(x{:});
            if ~continue_fcn(x{:})
                break;
            end
        else
            x = f(x);
            if ~continue_fcn(x)
                break;
            end
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
