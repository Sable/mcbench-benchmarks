function varargout = curly(x, varargin)

% out = curly(x, varargin)
% 
% Invoke curly brackets operator for x, passing in all further arguments.
% This is useful to select cells output from a function, skipping the need
% for intermediate variables. This is especially useful when writing
% anonymous functions.
%
% For example, we can select a single index.
% 
% >> curly({'soup', 1, [1 1 3 5 8 13]}, 1)
% ans =
% soup
%
% We can select a random index.
%
% >> curly({'soup', 1, [1 1 3 5 8 13]}, randi(3))
% ans =
%      1     1     3     5     8    13
%
% We can select multiple indices.
%
% >> [thing_1, thing_2] = curly({'soup', 1, [1 1 3 5 8 13]}, 1:2)
% thing_1 =
% soup
% thing_2 =
%      1
%
% We can also select all indices. Note that single quotes around the colon.
%
% >> [thing_1, thing_2, thing_3] = curly({'soup', 1, [1 1 3 5 8 13]}, ':')
% thing_1 =
% soup
% thing_2 =
%      1
% thing_3 =
%      1     1     3     5     8    13
%
% Tucker McClure
% Copyright 2013 The MathWorks, Inc.

    [varargout{1:nargout}] = x{varargin{:}};
    
end
