function out = paren(x, varargin)

% out = paren(x, varargin)
% 
% Invoke parenthesis operator for x, passing in all further arguments.
%
% For example:
% 
% >> magic(3)
% ans =
%      8     1     6
%      3     5     7
%      4     9     2
% >> paren(magic(3), 2, 1:3)
% ans =
%      3     5     7
% >> paren(magic(3), 2, :)
% ans =
%      3     5     7
%
% We can even use the parentheses to denote function execution. This just
% evaluates magic(4).
%
% >> paren(@magic, 4)
% ans =
%     16     2     3    13
%      5    11    10     8
%      9     7     6    12
%      4    14    15     1
%
% Tucker McClure
% Copyright 2013 The MathWorks, Inc.

    out = x(varargin{:});
    
end
