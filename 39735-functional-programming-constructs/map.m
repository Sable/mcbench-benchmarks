function varargout = map(vals, fcns, varargin)

% varargout = map(vals, fcns, varargin)
% 
% See functional_programming_examples.m for a discussion of this function.
% 
% Pass all of the inputs in |vals| (a cell array of arguments) to each
% function handle in the cell array |fcns|. Any additional arguments are
% passed to the |cellfun| function, such as 'UniformOutputs' or 
% 'ErrorHandler' properties.
% 
% >> map({1},  {@(x) 2*x, @asin})
% ans =
%     2.0000    1.5708
% >> map({3, 4},  {@(a, b) a + b, @max})
% ans =
%      7     4
% >> [min_or_max, indices] = map({[8 7 9]},  {@min, @max})
% min_or_max =
%      7     9
% indices =
%      2     3
% 
% Tucker McClure
% Copyright 2013 The MathWorks, Inc.

    if iscell(vals)
        [varargout{1:nargout}] = cellfun(@(f) f(vals{:}),fcns,varargin{:});
    else
        [varargout{1:nargout}] = cellfun(@(f) f(vals),fcns,varargin{:});
    end

end
