function S = similaritymat(idx, samples, n)
%SIMILARITYMAT Similarity matrix. 
% S = SIMILARITYMAT(IDX, SAMPLES, N) returns the N-by-N similarity matrix
% associated with the similarity of elements in the Ns-by-1 vector, IDX.
% The similarity value (0 or 1) is stored in the matrix S at the indices
% associated with the Ns-by-1 vector, SAMPLES
%
% Copyright (2009) Sandia Corporation. Under the terms of Contract 
% DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government retains 
% certain rights in this software.

S = zeros(n,n);

for i = 1:size(samples,1)
    S(samples(i),samples(i)) = 1;
    for j = (i+1):size(samples,1)
        if idx(i) == idx(j)
            S(samples(i),samples(j)) = 1;
            S(samples(j),samples(i)) = 1;
        end
    end
end