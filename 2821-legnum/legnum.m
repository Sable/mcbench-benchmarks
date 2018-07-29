%
% LEGNUM Legend current figure using array of numbers.
%    LEGNUM(X) adds a legend to current figure using string
%    representations of the numbers in X. If X is a two- or multi-dimensional
%    array, it will be flattened and all elements will be included.
%
%    LEGNUM(X, P) is the same but uses precision P, where P is an integer.
%
%    LEGNUM(X, P, S) same as above but includes a prefix string to
%    each legend label.
%
% Examples
%    legnum(logspace(-5,-4,7), 6);
%    Adds a legend with logarithmically-spaced number labels, with
%    6 significant digit precision
%
%    legnum(logspace(-5,-4,7), 6, 'x = ');
%    Same but labels are of the form 'x = 1e-5', etc.
%
% See also NUM2CELLSTR
%
%    Alex Barnett 12/5/02

function legnum(a, prec, prefix)

if nargin==1
  legend(num2cellstr(a));
elseif nargin==2
  legend(num2cellstr(a, prec));
elseif nargin==3
  legend(num2cellstr(a, prec, prefix));
else
  error('too many arguments to legnum.')
end
