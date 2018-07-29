function Uvec = triu2vec(Umat)
%TRIU2VEC  Convert upper triangular matrix into vector
%   TRIU2VEC(UMAT) takes the matrix UMAT and returns the
%   upper triangular part as a column vector.
%
%   See also TRIL2VEC, VEC2TRIU, VEC2TRIL
%
% © Copyright Phil Tresadern, University of Oxford, 2006

if (size(Umat,1) ~= size(Umat,2))
	error('Matrix is not square');
end
	
mask	= logical(triu(ones(size(Umat))));
Uvec	= Umat(mask);
