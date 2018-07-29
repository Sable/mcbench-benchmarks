function monotonic = ismonotonic(x, strict, direction, dim)
% ISMONOTONIC(X) returns a boolean value indicating whether or not a vector is monotonic.  
% By default, ISMONOTONIC returns true for non-strictly monotonic vectors,
% and both monotonic increasing and monotonic decreasing vectors. For
% matrices and N-D arrays, ISMONOTONIC returns a value for each column in
% X.
% 
% ISMONOTONIC(X, 1) works as above, but only returns true when X is
% strictly monotonically increasing, or strictly monotonically decreasing.
% 
% ISMONOTONIC(X, 0) works as ISMONOTONIC(X).
% 
% ISMONOTONIC(X, [], 'INCREASING') works as above, but returns true only
% when X is monotonically increasing.
% 
% ISMONOTONIC(X, [], 'DECREASING') works as above, but returns true only
% when X is monotonically decreasing.
% 
% ISMONOTONIC(X, [], 'EITHER') works as ISMONOTONIC(X, []).
% 
% ISMONOTONIC(X, [], [], DIM) works as above, but along dimension DIM.
% 
% NOTE: Third input variable is case insensitive, and partial matching is
% used, so 'd' would be recognised as 'DECREASING' etc..
% 
% EXAMPLE:
%     x = [1:4; 6:-2:2 3]
%     ismonotonic(x)
%     ismonotonic(x, [], 'i')
%     ismonotonic(x, [], [], 2)
% 
%     x =
%          1     2     3     4
%          6     4     2     3
%     ans = 
%          1     1     1     1
%     ans =
%          1     1     0     0
%     ans =
%          1
%          0
% 
% SEE ALSO: is*
% 
% $ Author: Richie Cotton $     $ Date: 2010/01/20 $    $ Version: 1.2 $


%% Basic error checking & default setup
if ~isreal(x) || ~isnumeric(x)
   warning('ismonotonic:badXValue', ...
       'The array to be tested is not real and numeric.  Unexpected behaviour may occur.'); 
end

if nargin < 2 || isempty(strict)
    strict = false;
end

if nargin < 3 || isempty(direction)
    direction = 'either';
end

% Accept partial matching for direction
lendir = length(direction);
if strncmpi(direction, 'increasing', lendir)
    testIncreasing = true;
    testDecreasing = false;
elseif strncmpi(direction, 'decreasing', lendir)
    testIncreasing = false;
    testDecreasing = true;
elseif strncmpi(direction, 'either', lendir) 
    testIncreasing = true;
    testDecreasing = true;
else
    warning('ismonotonic:badDirection', ...
        'The string entered for direction has not been recognised, reverting to ''either''.');
    testIncreasing = true;
    testDecreasing = true;
end

if nargin < 4 || isempty(dim)
    dim = find(size(x) ~= 1, 1);
    if isempty(dim)
        dim = 1;
    end
end

%% Test for monotonic increasing
if testIncreasing    
    if strict
        comparison = @gt;
    else
        comparison = @ge;
    end    
    monotonicAscending = all(comparison(diff(x, [], dim), 0), dim);
else
    monotonicAscending = false;
end

%% Test for monotonic decreasing
if testDecreasing    
    if strict
        fhComparison = @lt;
    else
        fhComparison = @le;
    end
    monotonicDescending = all(fhComparison(diff(x, [], dim), 0), dim);
else
    monotonicDescending = false;
end

monotonic = monotonicAscending | monotonicDescending;