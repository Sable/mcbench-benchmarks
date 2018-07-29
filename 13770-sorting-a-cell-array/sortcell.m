function Y = sortcell(X, DIM)
% SORTCELL    Sort a cell array in ascending order.
%
% Description: SORTCELL sorts the input cell array according to the
%   dimensions (columns) specified by the user.
%
% Usage: Y = sortcell(X, DIM)
%
% Input:
%	   X: the cell array to be sorted.
%  DIM: (optional) one or more column numbers. Simply an array of one or
%       more column numbers.  The first number is the primary column on
%       which to sort. Extra column numbers may be supplied if secondary
%       sorting is required. The defuault value is 1, if no dimension
%       array is supplied.
%
% Output:
%     Y: the sorted cell array.
%
% Example:    Y = sortcell(X, [3 2])
%
% Note that this function has only been tested on mixed cell arrays
% containing character strings and numeric values.
% 
% Documentation Date: Feb.01,2007 13:36:04
% 
% Tags:
% {TAG} {TAG} {TAG}
% 
% 

%   Copyright 2007  Jeff Jackson (Ocean Sciences, DFO Canada)
%   Creation Date: Jan. 24, 2007
%   Last Updated:  Jan. 25, 2007

% Check to see if no input arguments were supplied.  If this is the case,
% stop execution and output an error message to the user.
if nargin == 0
	error('No input arguments were supplied.  At least one is expected.');
% Check to see if the only input argument is a cell array.  If it isn't
% then stop execution and output an error message to the user. Also set the
% DIM value since it was not supplied.
elseif nargin == 1
	if ~iscell(X)
		error('Input argument is not a cell array.  A cell array is expected.');
	end
	DIM = 1;
% Check to see if the first input argument is a cell array and the second
% one is numeric.  If either check fails then stop execution and output an
% error message to the user.
elseif nargin == 2
	if ~iscell(X)
		error('The first input argument is not a cell array.  A cell array is expected.');
	end
	if ~isnumeric(DIM)
		error('The second input argument is not numeric.  At least one numeric value is expected.');
	end
% Check to see if too many arguments were input.  If there were then exit
% the function issuing a error message to the user.
elseif nargin > 2
	error('Too many input arguments supplied.  Only two are allowed.');
end

% Now find out if the cell array is being sorted on more than one column.
% If it is then use recursion to call the sortcell function again to sort
% the less important columns first. Repeat calls to sortcell until only one
% column is left to be sorted. Then return the sorted cell array to the
% calling function to continue with the higher priority sorting.
ndim = length(DIM);
if ndim > 1
	col = DIM(2:end);
	X = sortcell(X, col);
end

% Get the dimensions of the input cell array.
[nrows, ncols] = size(X);

% Retrieve the primary dimension (column) to be sorted.
col = DIM(1);

% Place the cells for this column in variable 'B'.
B = X(:,col);

% Check each cell in cell array 'B' to see if it contains either a
% character string or numeric value. If it is a character string it returns
% a '1' in the same location of boolean array 'a'; a '0' otherwise. If it
% is a numeric value it returns a '1' in the boolean array 'b'; a '0'
% otherwise.
a = cellfun('isclass', B, 'char');
suma = sum(a);
b = cellfun('isclass', B, 'double');
sumb = sum(b);

% Check to see if cell array 'B' contained only character string.
% If cell array B contains character strings then do nothing because
% no further content handling is required.
if suma == nrows
% Check to see if cell array 'B' contained only numeric values.
elseif sumb == nrows
  % If the cells in cell array 'B' contain numeric values retrieve the cell
  % contents and change 'B' to a numeric array.
  B = [B{:}];
else
	error('This column is mixed so sorting cannot be completed.');
end

% Sort the current array and return the new index.
[ix,ix] = sort(B);

% Using the index from the sorted array, update the input cell array and
% return it.
Y = X(ix,:);
