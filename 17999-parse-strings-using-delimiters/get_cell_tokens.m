function cell_tokens = get_cell_tokens(cell_array, delimiter)
% GET_CELL_TOKENS	 extracts all tokens from the cells of a cell array.
%
% Description:	GET_CELL_TOKENS extract all tokens from a string even if
%		one or more tokens are null.  It is a replacement to iteratively calling the
%		builtin function 'strtok.m' because it did not output null tokens as
%		would be normally expected.  Note that if there are two adjacent
%		delimiters then an empty token would be output representing the token
%		that could have been present between the delimiters.
%
% Usage:	cell_tokens = get_cell_tokens(cell_array, delimiter)
%
% Input:
%  cell_array: a cell array of strings from which to extract tokens.
%  delimiter:	a string containing one or more delimiters. The default
%    delimiters are whitespace characters (i.e. the ASCII codes for TAB,
%    LF, VT, FF, CR and space). Note that each delimiter is assumed to be
%    a single character; so if the delimiter string has three characters,
%    each of the three characters is considered a delimiter.
%
% Output:
% cell_tokens: A cell array containing cells of string tokens retrieved
%	  from the input cell array.
%
% Example:  
%
%  >> s = {'45;1980;stop;;678' 'what,a,day,'};
%  >> t = get_cell_tokens(s, ',;')
%
%	 t = 
% 
%     {5x1 cell}    {4x1 cell}
% 
% >> t{1}
% 
% ans = 
%     '45'
%     '1980'
%     'stop'
%     ''
%     '678'
% 
% >> t{2}
% 
% ans = 
%     'what'
%     'a'
%     'day'
%     ''
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Copyright 2007  Jeff Jackson (Ocean Sciences, DFO Canada)
%   Creation Date: Oct. 20, 2006
%   Last Updated:  Dec. 13, 2007
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Check the input arguments before continuing.

% Check to see if no input arguments were supplied.  If this is the case,
% stop execution and output an error message to the user.
if nargin == 0
  error('MATLAB:get_tokens:NrInputArguments', 'No input arguments were supplied. At least one is expected.');
% Check to see if the only input argument is a cell array.  If it isn't
% then stop execution and output an error message to the user. Also set the
% DIM value since it was not supplied.
elseif nargin == 1
	% Check to see if the input is a string.  Output a message if the input
	% value is a not a character array, then exit the function.
	if ~iscell(cell_array)
		error('MATLAB:get_tokens:InvalidInputArgument', 'The input parameter must be a valid cell array.');
	end
	% Set the default delimiter value to whitespace characters.
	delimiter = [9:13 32];
elseif nargin == 2
	% Check to see if the first input argument is a cell array and the second
	% is a character string.  If either check fails then stop execution and
	% output an error message to the user.
	if ~iscell(cell_array)
		error('MATLAB:get_tokens:InvalidInputArgument', 'The first input variable must be a valid cell array.');
	end
	if ~ischar(delimiter)
		error('MATLAB:get_tokens:InvalidInputArgument', 'The second input variable must be a valid character array.');
	end
elseif nargin > 2
	% Check to see if too many arguments were input.  If there were then exit
	% the function issuing a error message to the user.
	error('MATLAB:get_tokens:TooManyInputArguments', 'Too many input arguments were supplied.  The maximum permitted is two.');
end

%% If the input arguments are valid continue processing.

% Initiate output variable.
cell_tokens = cell(0);

% Get the size of the cell array. Iterate through the cell array storing
% the tokens of each string in the same cell location in the output cell
% array as in the input cell.
[m, n] = size(cell_array);

x = 0;
for i=1:m
	for j=1:n
		x = x + 1;
		% Convert the cell to a character array. Check to make sure that the
		% contents of the current cell are a character array.
		if ischar(cell_array{x})
			string = char(cell_array{x});
			if (nargin < 2)
				cell_tokens{x} = get_tokens(string);
			else
				cell_tokens{x} = get_tokens(string, delimiter);
			end
		else
			cell_tokens{x} = '';
		end
	end
end
