function Umat = vec2triu(Uvec)
%VEC2TRIU  Convert vector into upper triangular matrix
%   VEC2TRIU(UVEC) takes the vector UVEC and computes
%   an upper triangular matrix with corresponding elements.
%
%   See also VEC2TRIL, TRIU2VEC, TRIL2VEC
%
% © Copyright Phil Tresadern, University of Oxford, 2006

Uvec	= Uvec(:);

n 		= length(Uvec)*2;
n1		= floor(sqrt(n));
n2		= ceil(sqrt(n));
	
if ((n1*n2) ~= n)
	error('Number of elements is not triangular');
end

Umat 	= zeros(n1);

for col = 1:n1
	v1		= Uvec(1:col);
	Uvec	= Uvec(col+1:size(Uvec,1));

	Umat(1:col,col) = v1;
end
