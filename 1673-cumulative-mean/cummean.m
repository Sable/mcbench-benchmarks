function y = cummean(x,dim)
%CUMMEAN   Average cumulative mean.
%   For vectors, CUMMEAN(X) is the cumulative mean value of the elements in X.
%   For matrices, CUMMEAN(X) is a row vector containing the mean cumulative value of
%   each column.  For N-D arrays, CUMMEAN(X) is the mean cumulative value of the
%   elements along the first non-singleton dimension of X.
%
%   CUMMEAN(X,DIM) takes the cummulative mean along the dimension DIM of X.
%
%   Example: If X = [0 1 2
%                    3 4 5]
%
%   then cummean(X,1) is   [  0   1   2
%                           1.5 2.5 3.5]
%   and cummean(X,2)  is   [  0 0.5   1
%                             3 3.5   4]
%
%   Another example:
%   Calculate the cumulative mean of an uniform random vector
%   in order to estimate its mean (0.5).
%
%   y=rand(100,1);
%   plot(y,'bo:');hold on;plot(cummean(y),'r-');
%
%   See also CUMSUM, MEAN, MEDIAN, STD, MIN, MAX, COV.

%   Copyright (c) 2001 by Leandro G. Barajas
%   Based on CUMSUM by Mathworks
%   $Revision: 1.0 $  $Date: 05/07/02 14:00:56 $

if nargin==1,
  % Determine which dimension SUM./[1:N] will use
  dim = min(find(size(x)~=1));
  if isempty(dim), dim = 1; end
end

siz = [size(x) ones(1,dim-ndims(x))];
n = size(x,dim);

% Permute and reshape so that DIM becomes the row dimension of a 2-D array
perm = [dim:max(length(size(x)),dim) 1:dim-1];
x = reshape(permute(x,perm),n,prod(siz)/n);

% Calculate cummulative mean
y = cumsum(x,1)./repmat([1:n]',1,prod(siz)/n);

% Permute and reshape back
y = ipermute(reshape(y,siz(perm)),perm);




