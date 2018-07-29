function Y = vectorindex(A,X)
%VECTORINDEX evaluates an n-dimensional array for a vector of indices.
%
%   VECTORINDEX evaluates an n-dimensional array at the indices specified 
%   in vector form.  For example, if v=[1;3;1] and A is a 3-dimensional
%   array, then vectorindex(A,v) is the same as A(1,3,1).
%    
%   Y = VECTORINDEX(A,X) evaluates the n-dimensional array A at the indices
%   specified in each column of X.  The outputs are stored in the vector Y
%   such that Y(j) = VECTORINDEX(A,X(:,j)).
%
%   See also EVAL, SUB2IND.

sizeA = size(A);
d = length(sizeA);
if size(X,1)~=d, error('Each column of X must contain the same number of elements as the number of dimensions of A.'); end
if any(X<=0), error('X must contain positive integers corresponding to indices.'); end
outOfBounds = repmat(sizeA.',1,size(X,2))-X<0;
if sum(outOfBounds(:))~=0, error('Index out of bounds.'); end
k = [1, cumprod(sizeA(1:end-1))];
lininds = 1 + k*(X-1);
Y = A(lininds);