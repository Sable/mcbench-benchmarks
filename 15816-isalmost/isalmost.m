function test = isalmost(a,b,tol)
%
% usage: test = isalmost(a,b,tol)
%
% tests if matrix a is approximately equal to b within a specified 
% tolerance interval (b-tol <= a <= b+tol)
%
% note:  if b is given as a scalar, all values in a are compared against
%        the scalar value b
%
% calls: none
%
% inputs:
%
% a(nr,nc) = matrix of data values to test
% b(nr,nc) = matrix of data values for comparison (or a single scalar value)
%      tol = tolerance used in computation
%
% outputs:
%
% test(nr,nc) = matrix of test results:
%
%        test(i,j) = 0 -> a(i,j) is not equal to b(i,j) (or is NaN)
%        test(i,j) = 1 -> a(i,j) is approximately equal to b(i,j)
%
%   author : James Crawford 
%   created 01/08/2007
%
%   history: v1.0 (01/08/2007)
%

% get length of input matrix a
[nr,nc] = size(a);

% check input for consistency
if ~all(size(a) == size(b))
   if all(size(b) == [1 1])
      % convert scalar value b to a matrix of size(a)
      b = b*ones(size(a));
   else
      disp('error: input arguments are inconsistent (isalmost.m)')
      disp('(b) must be a matrix of same size as (a) or a single value')
   end
end
one = ones(size(b));

% perform test
test = (a <= b+tol*one)&(a >= b-tol*one);
%