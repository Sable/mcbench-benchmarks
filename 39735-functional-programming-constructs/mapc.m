function varargout = mapc(values, fcns, varargin)

% varargout = mapc(value, fcns, varargin)
%
% See functional_programming_examples.m for a discussion of this function.
% 
% Pass all of the inputs in |values| (a cell array of arguments) to each
% function handle in the cell array |fcns|, allowing output size to vary.
% The output is therefore a cell array instead of an array. Any additional
% arguments are passed to the |cellfun| function, such as the 
% 'ErrorHandler' property.
% 
% >> mapc({1}, {@(x) 2*x, @asin, @(x) char(x+[115 110 108 96 115 110])})
% ans = 
%     [2]    [1.5708]    'tomato'
% 
% Tucker McClure
% Copyright 2013 The MathWorks, Inc.

    [varargout{1:nargout}] = cellfun(@(f) f(values{:}), fcns, ...
                                     'UniformOutput', false, varargin{:});

end
