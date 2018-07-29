function Umat = vec2sym(Uvec)
%VEC2SYM  Convert vector to symmetric matrix
%   VEC2SYM(UVEC) takes the vector UVEC and returns the
%   symmetric matrix composed of its elements.
%
%   See also SYM2VEC
%
% © Copyright Phil Tresadern, University of Oxford, 2006

Uvec	= Uvec(:);

n 		= length(Uvec)*2;
n1		= floor(sqrt(n));
n2		= ceil(sqrt(n));
	
if ((n1*n2) ~= n)
	error('Number of elements is not triangular');
end
	
temp	= vec2triu(Uvec);
Umat	= temp + temp' - diag(diag(temp));
