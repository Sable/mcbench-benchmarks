%
% NUM2CELLSTR convert array of floating-point numbers to cell array of strings
%    NUM2CELLSTR(X) converts array X to cell array of strings.
%    If X is a two- or multi-dimensional array, it will be
%    flattened (all elements will still be included).
%
%    NUM2CELLSTR(X, P) is the same but uses precision P, where P is an integer.
%
%    NUM2CELLSTR(X, P, S) same as above but includes a prefix string to
%    each cell.
%
%    This clumsy routine would be unnecessary if Matlab provided something
%    like python's string.strip() function.
%
% See also SPRINTF, CELLSTR
%
%    Alex Barnett 12/5/02

function [c] = num2cellstr(a, prec, prefix)

if nargin==1
  prec = 4;      % default precision
else
  if prec<1
    error('precision must be at least 1.')
  end
  if prec>16
    error('precision cannot exceed 16.')
  end
end
if nargin<3
  prefix = ''; % default prefix
end

l = 25;          % max number of characters for representing a number
n = numel(a);

% build printf format string
f = sprintf('%%-%d.%dg', l, round(prec));

c = cellstr([repmat(prefix, [n 1]) reshape(sprintf(f, a),[l, n])']);
