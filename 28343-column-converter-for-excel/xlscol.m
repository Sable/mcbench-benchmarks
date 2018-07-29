function b = xlscol(a)

%XLSCOL Convert Excel column letters to numbers or vice versa.
%   B = XLSCOL(A) takes input A, and converts to corresponding output B.
%   The input may be a number, a string, an array or matrix, an Excel
%   range, a cell, or a combination of each within a cell, including nested
%   cells and arrays. The output maintains the shape of the input and
%   attempts to "flatten" the cell to remove nesting.  Numbers and symbols
%   within strings or Excel ranges are ignored.
%
%   Examples
%   --------
%       xlscol(256)   % returns 'IV'
%
%       xlscol('IV')  % returns 256
%
%       xlscol([405 892])  % returns {'OO' 'AHH'}
%
%       xlscol('A1:IV65536')  % returns [1 256]
%
%       xlscol({8838 2430; 253 'XFD'}) % returns {'MAX' 'COL'; 'IS' 16384}
%
%       xlscol(xlscol({8838 2430; 253 'XFD'})) % returns same as input
%
%       b = xlscol({'A10' {'IV' 'ALL34:XFC66'} {'!@#$%^&*()'} '@#$' ...
%         {[2 3]} [5 7] 11})
%       % returns {1 [1x3 double] 'B' 'C' 'E' 'G' 'K'}
%       %   with b{2} = [256 1000 16383]
%
%   Notes
%   -----
%       CELLFUN and ARRAYFUN allow the program to recursively handle
%       multiple inputs.  An interesting side effect is that mixed input,
%       nested cells, and matrix shapes can be processed.
%
%   See also XLSREAD, XLSWRITE.
%
%   Version 1.1 - Kevin Crosby

% DATE      VER  NAME          DESCRIPTION
% 07-30-10  1.0  K. Crosby     First Release
% 08-02-10  1.1  K. Crosby     Vectorized loop for numerics.

% Contact: Kevin.L.Crosby@gmail.com

base = 26;
if iscell(a)
  b = cellfun(@xlscol, a, 'UniformOutput', false); % handles mixed case too
elseif ischar(a)
  if ~isempty(strfind(a, ':')) % i.e. if is a range
    b = cellfun(@xlscol, regexp(a, ':', 'split'));
  else % if isempty(strfind(a, ':')) % i.e. if not a range
    b = a(isletter(a));        % get rid of numbers and symbols
    if isempty(b)
      b = {[]};
    else % if ~isempty(a);
      b = double(upper(b)) - 64; % convert ASCII to number from 1 to 26
      n = length(b);             % number of characters
      b = b * base.^((n-1):-1:0)';
    end % if isempty(a)
  end % if ~isempty(strfind(a, ':')) % i.e. if is a range
elseif isnumeric(a) && numel(a) ~= 1
  b = arrayfun(@xlscol, a, 'UniformOutput', false);
else % if isnumeric(a) && numel(a) == 1
  n = ceil(log(a)/log(base));  % estimate number of digits
  d = cumsum(base.^(0:n+1));   % offset
  n = find(a >= d, 1, 'last'); % actual number of digits
  d = d(n:-1:1);               % reverse and shorten
  r = mod(floor((a-d)./base.^(n-1:-1:0)), base) + 1;  % modulus
  b = char(r+64);  % convert number to ASCII
end % if iscell(a)

% attempt to "flatten" cell, by removing nesting
if iscell(b) && (iscell([b{:}]) || isnumeric([b{:}]))
  b = [b{:}];
end % if iscell(b) && (iscell([b{:}]) || isnumeric([ba{:}]))

