function out = void(f, out)

% out = void(f, out)
% 
% This is a helper function to enable more complex anonymous functions.
%
% While some functions don't return anything, it can be useful to return
% something after calling them. This function calls the input function and
% then returns either 1 (the default) or the second input, which can be any
% value of the user's choosing. Consider the following anonymous function:
%
% plot_it = @() {figure(1), ...
%                clf(), ...
%                plot(randn(1, 50), '.'), ...
%                axis('off')};
%
% plot_it() % This throws an error.
% 
% Clearly, this should open a figure, clear it, plot some points, and turn
% off the axis. However, the axis('off') command doesn't return anything,
% and something is necessary for that position of the cell array, so MATLAB
% throws an error. However, if we just pass the function to the "void"
% command, as below, it works just fine, returning a 1 that we simply don't
% use but that fills the cell array as MATLAB requires.
%
% plot_it = @() {figure(1), ...
%                clf(), ...
%                plot(randn(1, 50), '.'), ...
%                void(@() axis('off'))};
%
% plot_it() % This works.
%
% Tucker McClure
% Copyright 2013 The MathWorks, Inc.

    if nargin == 1, out = 1; end
    f();
    
end
