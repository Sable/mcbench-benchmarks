function varargout = tern(condition, true_action, false_action)

% out = tern(condition, true_action, false_action)
% 
% Ternary operator. If the first input is true, it returns the second
% input. Otherwise, it returns the third input. This is useful for writing
% compact functions and especially anonymous functions. Note that, like
% many other languages, if the condition is true, not only is the false
% condition not returned, it isn't even executed. Likewise, if the
% condition is false, the true action is never executed. The second and
% third arguments can therefore be function handles or values.
%
% Example:
%
% >> tern(rand < 0.5, @() fprintf('hi\n'), pi)
% ans =
%     3.1416
% >> tern(rand < 0.5, @() fprintf('hi\n'), pi)
% hi
%
% It works with multiple outputs as well.
%
% >> [min_or_max, index] = tern(rand < 0.5, ...
%                               @() min([4 3 5]), ...
%                               @() max([4 3 5]))
% min_or_max =
%      5
% index =
%      3
%
% Tucker McClure
% Copyright 2013 The MathWorks, Inc.

    if condition() % Works for either a value or function handle.
        [varargout{1:nargout}] = true_action();
    else
        [varargout{1:nargout}] = false_action();
    end

end
