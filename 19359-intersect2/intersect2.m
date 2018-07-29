function result = intersect2(cell)

% PURPOSE:
%   This function finds the common elements of several 1D numeric arrays 
%   of the same or different sizes and returns an array consisting of only 
%   those elements.
%
% INPUT:
%   The input variable "cell" has to be a cell array, with each cell
%   occupied by an 1D numeric array. For example, if you want to find the 
%   intersection (common elements) of the following three arrays
%       a = [ 1 3 4 6 8 9 ];
%       b = [ 3 1 0 8 6 4 ];
%       c = [ 7 8 1 9 3 4 ];,
%   you need to first put all of them into a cell array, i.e.
%       cell = {a, b, c};
%   Then you could use "cell" as the input variable to this function, i.e.
%       result = intersect2(cell);
%   
% OUTPUT:
%   The output of this function is simply an array consisting of elements
%   that are common to all the arrays stored in "cell". For the particular
%   case in the example above, the output would be
%       result = [ 1 3 4 8 ];
%   Also note that the numbers in the result are sorted in ascending order.

n = max(size(cell));

if n == 2
    result = intersect(cell{1, 1}, cell{1, 2});
elseif (n > 2 && rem(n,2) == 0)
    for i = 1:(n/2)
        intersections{1, i} = intersect(cell{1, i}, cell{1, n-i+1});
    end
elseif (n > 2 && rem(n,2) == 1)
    for i = 1:((n-1)/2)
        intersections{1, i} = intersect(cell{1, i}, cell{1, n-i+1});
    end
        intersections{1, i+1} = cell{1, (n+1)/2}; 
else
    error('You need at least two arrays as inputs');
end

if n > 2
    result = intersect2(intersections);
end