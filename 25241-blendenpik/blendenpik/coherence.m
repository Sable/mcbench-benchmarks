function [mu, row] = coherence(A)
% [mu, row] = coherence(A)
%
% Finds the coherence of the matrix A.
% Let U be a orthonormal basis for the column space of A. The coherence
% of A is equal to the maximum squared row norm of U.
% 
% Output:
%   mu - the coherence.
%   row - row which held the largest row norm.
%
% 6-December 2009, Version 1.3
% Copyright (C) 2009, Haim Avron and Sivan Toledo.

[Q, R] = qr(A, 0);
[mu, row] = max(sum(Q .* Q, 2));