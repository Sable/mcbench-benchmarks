function S = distmat(x)
%DISTMAT Distance matrix. 
% S = DISTMAT(X) returns the N-by-N distance matrix representing Euclidean
% distances (negative valued) between an N-by-D matrix of points. 
%
% Copyright (2009) Sandia Corporation. Under the terms of Contract 
% DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government retains 
% certain rights in this software.

S = zeros(size(x,1),size(x,1));

for i = 1:size(x,1)
    for j = (i+1):size(x,1)
        S(i,j) = -norm(x(i,1:2)-x(j,1:2))^2;
        S(j,i) = S(i,j);
    end
end
