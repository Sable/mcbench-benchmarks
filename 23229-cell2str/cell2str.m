function str = cell2str(c)
% Convert a cell array of strings into an array of strings.
% CELL2STR pads each string in order to force all strings
% have the same length.
%

% Determine the length of each string in cell array c
nblanks = cellfun(@length, c);
maxn = max(nblanks);
nblanks = maxn-nblanks; 

% Create a cell array of blanks.  Each column of the cell array contains
% the number of blanks necessary to pad each row of the converted string
padding = cellfun(@blanks,num2cell(nblanks), 'UniformOutput', false);

% Concatinate cell array and padding
str = {c{:}; padding{:}};

% This operation converts new the cell array into a string
str = [str{:}];

% Reshape the string into an array of strings
ncols = maxn;
nrows = length(str)/ncols;
str = reshape(str,ncols,nrows)';