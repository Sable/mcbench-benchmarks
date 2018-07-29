function strCell = num2cellstr(x, format)
% num2CellStr - converts numeric or logical array to a cell array of strings
%
% Syntax:
%
% strCell = num2CellStr(x, format)
%
% Input parameters:
%
%
%       x         - mandatory matrix of numeric values
%       format    - optional format specifier.  If not specified one is
%                   picked based on the data up to 5 decimal places
%
%
% Output parameters:
%
%       strCell   - cell array of strings
%
%
% Examples:
%
% num2CellStr(rand(2),'%.2f')
% 
% ans = 
% 
%     '0.06'    '0.61'
%     '0.13'    '0.39'
%
% See also:
% num2cell, mat2cell, textscan, strread

% Author: Andrew Watson
% email: andruwatson@yahoo.co.uk
% Matlab Release: R2007b

% History
% Release 1.0, 09-Jul-2008 20:11:39 - created

%% Numbers to cell array of strings

% error checking
error(nargchk(1, 2, nargin));

if ~isnumeric(x) && ~islogical(x)
    error('AJW:num2CellStr:invalidData','Data must be numeric.');
elseif isa(x, 'int64') || isa(x, 'uint64')
    error('AJW:num2CellStr:unsupportedDataType','Unsupported data type.');
end

% Anything to do?
if isempty(x)
    strCell = [];
    return
end

% Format specified?
if nargin < 2 || isempty(format)
    format = i_GetFormat(x);
elseif ~ischar(format)
    error('AJW:num2CellStr:invalidFormat','Invalild format specified.');
end

% Pick a delimiter
delimiter = '$';
    
% sprintf the data with a delimiter
strCell = sprintf([format, delimiter], x);

% If nothing was returned an invalid format was specified
if isempty(strCell)
    error('AJW:num2CellStr:invalidFormat','Invalild format specified.');
end

% Now farm it off to strread
strCell = strread(strCell, '%s', 'delimiter', delimiter);

% Any problems?
if numel(strCell) ~= numel(x) || (numel(strCell) == 1 && ...
        ~isempty(strmatch(format, strCell, 'exact')))
    error('AJW:num2CellStr:invalidFormat','Invalild format string.');
end

% reshape needed
strCell = reshape(strCell, size(x));

%% Get a sensible format up to 5 dp from input data
function format = i_GetFormat(x)

% Get a sensible format string
format = '%d';

if all(all(rem(x, 1) ~=0))
    
    %try to preserve as much information as possible
    for i = 0:5
        format = sprintf('%%.%df', i);
        if all(all(rem(x, 10.^-i) < eps))
            break
        end
    end
    
end