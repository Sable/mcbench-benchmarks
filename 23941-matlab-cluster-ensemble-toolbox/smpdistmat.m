function S = smpdistmat(Sd, samples)
%SMPDISTMAT Sampled distance matrix. 
% S = SMPDISTMAT(SD, SAMPLES) returns the Ns-by-Ns distance matrix, S,
% comprised of elements from the N-by-N distance matrix SD, associated with
% indices given by the Ns-by-1 vector, SAMPLES.
%
% Copyright (2009) Sandia Corporation. Under the terms of Contract 
% DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government retains 
% certain rights in this software.

S = zeros(size(samples,1),size(samples,1));

for i = 1:size(samples,1)
    for j = (i+1):size(samples,1)
        S(i,j) = Sd(samples(i),samples(j));
        S(j,i) = S(i,j);
    end
end
