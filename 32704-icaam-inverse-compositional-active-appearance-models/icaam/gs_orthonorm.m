function O = gs_orthonorm(M)
% O = gs_orthonorm(M)
%
% Classic Gram-Schmidt orthonormalization.
% 
%                         PARAMETERS
%
% M A matrix with columns to be orthonormalized.
%
%                        RETURN VALUES
%
% O A matrix with orthonormal columns spanning the same 
%   space as the columns in M. Linearly dependent vectors 
%   are removed from the result.
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)
	
	ncol = size(M, 2);
	
	% Zero threshold
	tol = 100 * eps;
	
	% Index to result column
	k = 1;
	
	for i=1:ncol
		% Column to orthogonalize
		v = M(:,i);

		% Subtract projections over previous vectors
		for j=1:k-1
			v = v - (O(:,j)' * v) * O(:,j);
		end
		
		% Only keep nonzero vectors
		n = norm(v);
		if n > tol
			% Normalize and store
			O(:,k) = v / n;
			k = k + 1;
		end
	end