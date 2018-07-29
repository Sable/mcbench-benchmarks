function out = mat2clip(a, delim)

%MAT2CLIP  Copies matrix to system clipboard.
%
% MAT2CLIP(A) copies the contents of 2-D matrix A to the system clipboard.
% A can be a numeric array (floats, integers, logicals), character array,
% or a cell array. The cell array can have mixture of data types.
%
% Each element of the matrix will be separated by tabs, and each row will
% be separated by a NEWLINE character. For numeric elements, it tries to
% preserve the current FORMAT. The copied matrix can be pasted into
% spreadsheets.
%
% OUT = MAT2CLIP(A) returns the actual string that was copied to the
% clipboard.
%
% MAT2CLIP(A, DELIM) uses DELIM as the delimiter between columns. The
% default is tab (\t).
%
% Example:
%   format long g
%   a = {'hello', 123;pi, 'bye'}
%   mat2clip(a);
%   % paste into a spreadsheet
%
%   format short
%   data = {
%     'YPL-320', 'Male',   38, true,  uint8(176);
%     'GLI-532', 'Male',   43, false, uint8(163);
%     'PNI-258', 'Female', 38, true,  uint8(131);
%     'MIJ-579', 'Female', 40, false, uint8(133) }
%   mat2clip(data);
%   % paste into a spreadsheet
%
%   mat2clip(data, '|');   % using | as delimiter
%
% See also CLIPBOARD.

% VERSIONS:
%   v1.0 - First version
%   v1.1 - Now works with all numeric data types. Added option to specify
%          delimiter character.
%
% Copyright 2009 The MathWorks, Inc.
%
% Inspired by NUM2CLIP by Grigor Browning (File ID: 8472) Matlab FEX.

error(nargchk(1, 2, nargin, 'struct'));

if ndims(a) ~= 2
  error('mat2clip:Only2D', 'Only 2-D matrices are allowed.');
end

% each element is separated by tabs and each row is separated by a NEWLINE
% character.
sep = {'\t', '\n', ''};

if nargin == 2
  if ischar(delim)
    sep{1} = delim;
  else
    error('mat2clip:CharacterDelimiter', ...
      'Only character array for delimiters');
  end
end

% try to determine the format of the numeric elements.
switch get(0, 'Format')
  case 'short'
    fmt = {'%s', '%0.5f' , '%d'};
  case 'shortE'
    fmt = {'%s', '%0.5e' , '%d'};
  case 'shortG'
    fmt = {'%s', '%0.5g' , '%d'};
  case 'long'
    fmt = {'%s', '%0.15f', '%d'};
  case 'longE'
    fmt = {'%s', '%0.15e', '%d'};
  case 'longG'
    fmt = {'%s', '%0.15g', '%d'};
  otherwise
    fmt = {'%s', '%0.5f' , '%d'};
end

if iscell(a)  % cell array
    a = a';
    
    floattypes = cellfun(@isfloat, a);
    inttypes = cellfun(@isinteger, a);
    logicaltypes = cellfun(@islogical, a);
    strtypes = cellfun(@ischar, a);
    
    classType = zeros(size(a));
    classType(strtypes) = 1;
    classType(floattypes) = 2;
    classType(inttypes) = 3;
    classType(logicaltypes) = 3;
    if any(~classType(:))
      error('mat2clip:InvalidDataTypeInCell', ...
        ['Invalid data type in the cell array. ', ...
        'Only strings and numeric data types are allowed.']);
    end
    sepType = ones(size(a));
    sepType(end, :) = 2; sepType(end) = 3;
    tmp = [fmt(classType(:));sep(sepType(:))];
    
    b=sprintf(sprintf('%s%s', tmp{:}), a{:});

elseif isfloat(a)  % floating point number
    a = a';
    
    classType = repmat(2, size(a));
    sepType = ones(size(a));
    sepType(end, :) = 2; sepType(end) = 3;
    tmp = [fmt(classType(:));sep(sepType(:))];
    
    b=sprintf(sprintf('%s%s', tmp{:}), a(:));

elseif isinteger(a) || islogical(a)  % integer types and logical
    a = a';
    
    classType = repmat(3, size(a));
    sepType = ones(size(a));
    sepType(end, :) = 2; sepType(end) = 3;
    tmp = [fmt(classType(:));sep(sepType(:))];
    
    b=sprintf(sprintf('%s%s', tmp{:}), a(:));

elseif ischar(a)  % character array
    % if multiple rows, convert to a single line with line breaks
    if size(a, 1) > 1
      b = cellstr(a);
      b = [sprintf('%s\n', b{1:end-1}), b{end}];
    else
      b = a;
    end
    
else
    error('mat2clip:InvalidDataType', ...
      ['Invalid data type. ', ...
      'Only cells, strings, and numeric data types are allowed.']);

end

clipboard('copy', b);

if nargout
  out = b;
end