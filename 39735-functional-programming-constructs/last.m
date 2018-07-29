function out = last(varargin)

% out = last(varargin)
% 
% This function is useful when entering multiple commands in a sequence
% inside a cell array, but when only the last output is needed going
% forward. For instance, this is frequently useful in loops.
%
% Given:
%
%     last(fprintf('Factorial(%d): %d\n', k, k*x), k*x)
%
% |last| returns |k*x|, as in this one-line factorial:
%
% forloop(1, 9, @(x, k) last(fprintf('Factorial(%d): %d\n', k, k*x), k*x))
% 
% Tucker McClure
% Copyright 2013 The MathWorks, Inc.

    out = varargin{end};
    
end
