function [ B ] = reciprocal_lattice( A )
%RECIPROCAL_LATTICE Find the reciprocal lattice.
%   B = RECIPROCAL_LATTICE(A) returns the lattice vectors (as
%   rows of B) for the reciprocal lattice of the lattice whose lattice
%   vectors are given by the rows of A.

    B = 2*pi*inv(A)';
end

