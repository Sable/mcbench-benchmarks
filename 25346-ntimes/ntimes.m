% NTIMES.m
% C=NTIMES(A,B) computes the matrix product of A and B.  When A and B are
%	both two dimensional matrices, then the result C will be identical to
%	the output of Matlab's MTIMES function.  If A and B have higher
%	dimension than two, then this function treats A and B as matrices of
%	2-D matrices, and performs matrix-wise	multiplication
%	element-by-element.
%
% Written by Ampere Kui, 2009.

function c = ntimes(a, b)
	% Calculate the size of both matrices.
	s_a = size(a);
	s_b = size(b);
	
	% Using the size of the matrices, calculate the permutation indices
	% that we will need to perform matrix multiplication:
	% C(i,j) = dot(A(i,r), B(r,j))
	i = 1:s_a(1);	% Row indices of A.
	r = 1:s_a(2);	% Col indices of A.
	j = 1:s_b(2);	% Col indices of B.
	i = repmat(i, [1 s_b(2)]);
	j = repmat(j, [s_a(1) 1]);
		
	% Perform a transpose on B by switching dimensions 1 and 2.
	b = permute(b, [2 1 3:ndims(b)]);
	
	% Set up P and Q matrices such that when we compute the dot product, we
	% would obtain the matrix-wise product of A and B across all
	% dimensions.
	p = a(i(:), r, :);
	q = b(j(:), r, :);
	c = reshape(dot(p, q, 2), [s_a(1) s_b(2) s_a(3:end)']);