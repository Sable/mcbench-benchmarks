function varargout = iif(varargin)

% out = iif(conditions_actions)
% 
% This is an inline form of "if", allowing one to use "if" as a function.
% Generally, the form looks like:
%
% iif(<if this>,      <then that>, ...
%     <else if this>, <then that>);
%
% That is, the odd inputs are treated as conditions and the even inputs are
% treated as the actions to be performed. The action corresponding to the 
% first true condition is executed.
%
% For example, consider normalizing a vector, x.
%
% x_hat = iif(all(x == 0), @() x, ...
%             true,        @() x/sqrt(sum(x.^2)))
%
% Consider writing an anonymous function to safely normalize x.
%
% safe_normalize = @(x) iif(all(x == 0), @() x, ...
%                           true,        @() x/sqrt(sum(x.^2)));
%
% To avoid calculating *all* possible conditions before determing which
% action to perform, the conditions can be expressed as anonymous functions
% to execute. These will be executed in order until a condition returning
% true is found. Here the same example as the above, with "@()" added
% before each condition to prevent its execution until it's needed (and
% skipping it altogether when it's not needed). This can be useful for
% conditions that take a long time to evaluate. Note that this syntax is
% likely slower than the above when the conditions are easy to execute.
%
% safe_normalize = @(x) iif(@() all(x == 0), @() x, ...
%                           @() true,        @() x/sqrt(sum(x.^2))); 
%
% See functional_programming_examples.m for more.
% 
% Tucker McClure
% Copyright 2013 The MathWorks, Inc.

    % The user of a single structure for conditions and actions is meant to
    % make it easy to call the function with "if left, then do right"
    % syntax like the example above.
    conditions = varargin(1:2:end);
    actions    = varargin(2:2:end);
    
    % The conditions mights be an array of true/false *or* a cell array of
    % function handles to call that should return true/false. Find the
    % first true one. If function handles, evaluate in order so only the
    % necessary conditions are evaluated.
    if isa(conditions{1}, 'function_handle')
        condition = recur(@(f, n) iif(conditions{n}(), @() n, ...
                                      true,            @() f(f, n+1)), 1);
    else
        condition = find([conditions{:}], 1, 'first');
    end
    
    % Perform the correct action.
    if ~isempty(condition)
        [varargout{1:nargout}] = actions{condition}();
    else
        [varargout{1:nargout}] = [];
    end
    
end
