function disptable(M, col_strings, row_strings, fmt, spaces)
%DISPTABLE Displays a matrix with per-column or per-row labels.
%   DISPTABLE(M, COL_STRINGS, ROW_STRINGS)
%   Displays matrix or vector M with per-column or per-row labels,
%   specified in COL_STRINGS and ROW_STRINGS, respectively. These can be
%   cell arrays of strings, or strings delimited by the pipe character (|).
%   Either COL_STRINGS or ROW_STRINGS can be ommitted or empty.
%   
%   DISPTABLE(M, COL_STRINGS, ROW_STRINGS, FMT, SPACES)
%   FMT is an optional format string or number of significant digits, as
%   used in NUM2STR. It can also be the string 'int', as a shorthand to
%   specify that the values should be displayed as integers.
%   SPACES is an optional number of spaces to separate columns, which
%   defaults to 1.
%   
%   Example:
%     disptable(magic(3)*10-30, 'A|B|C', 'a|b|c')
%   
%   Outputs:
%        A    B    C
%    a  50  -20   30
%    b   0   20   40
%    c  10   60  -10
%   
%   Author: João F. Henriques, April 2010


	%parse and validate inputs

	if nargin < 2, col_strings = []; end
	if nargin < 3, row_strings = []; end
	if nargin < 4, fmt = 4; end
	if nargin < 5, spaces = 2; end
	
	if strcmp(fmt, 'int'), fmt = '%.0f'; end  %shorthand for displaying integer values
	
	assert(ndims(M) <= 2, 'Can only display a vector or two-dimensional matrix.')
	
	num_rows = size(M,1);
	num_cols = size(M,2);

	use_col_strings = true;
	if ischar(col_strings),  %convert "|"-delimited string to cell array of strings
		col_strings = textscan(col_strings, '%s', 'delimiter','|');
		col_strings = col_strings{1};
		
	elseif isempty(col_strings),  %empty input; have one empty string per column for consistency
		col_strings = cell(num_cols,1);
		use_col_strings = false;
		
	elseif ~iscellstr(col_strings),
		error('COL_STRINGS must be a cell array of strings, or a string with "|" as a delimiter.');
	end

	use_row_strings = true;
	if ischar(row_strings),  %convert "|"-delimited string to cell array of strings
		row_strings = textscan(row_strings, '%s', 'delimiter','|');
		row_strings = row_strings{1};
		
	elseif isempty(row_strings),  %empty input; have one empty string per row for consistency
		row_strings = cell(num_rows,1);
		use_row_strings = false;
		
	elseif ~iscellstr(row_strings),
		error('ROW_STRINGS must be a cell array of strings, or a string with "|" as a delimiter.');
	end
	
	assert(~use_col_strings || numel(col_strings) == num_cols, ...
		'COL_STRINGS must have one string per column of M, or be empty.')
	
	assert(~use_row_strings || numel(row_strings) == num_rows, ...
		'ROW_STRINGS must have one string per column of M, or be empty.')
	
	assert(isscalar(fmt) || (isvector(fmt) && ischar(fmt)), ...
		'Format must be a format string or the number of significant digits (as in NUM2STR).')
	
	
	
	%format the table for display
	
	col_text = cell(num_cols,1);  %the text of each column
	
	%spaces to separate columns
	if use_col_strings,
		blank_column = repmat(' ', num_rows + 1, spaces);
	else
		blank_column = repmat(' ', num_rows, spaces);
	end
	
	for col = 1:num_cols,
		%convert this column of the matrix to its string representation
		str = num2str(M(:,col), fmt);
		
		%add the column header on top and automatically pad, returning a
		%character array
		if use_col_strings,
			str = char(col_strings{col}, str);
		end
		
		%right-justify and add blanks to separate from previous column
		col_text{col} = [blank_column, strjust(str, 'right')];
	end
	
	%turn the row labels into a character array, with a blank line on top
	if use_col_strings,
		left_text = char('', row_strings{:});
	else
		left_text = char(row_strings{:});
	end
	
	%concatenate horizontally the character arrays and display
	disp([left_text, col_text{:}])
	disp(' ')
	
end

