function [B,P] = permm(A,idp)
% PERMM Permutates a matrix A by given indexes by computing B = P'*A*P
% 
% B     = permm(A,idp)
% [B,P] = permm(A,idp)
% 
% The function applies simultaneous column and row permutation, that is by
% given indexes idp = [k j m ...] the function rearranges the elements of A
% so that B11=Akk, B12=Akj, ...  B21 = Ajk, B22=Ajj, ...
% 
% Example
% A   = [11 12 13;
%        21 22 23;
%        31 32 33]      % initial matrix
% idp = [2 3 1]         % order of rearrangement
% B = permm(A, idp);    % rearranged matrix

% Andrey Popov      andrey.popov @ gmx.net                      29.10.2009

% Copyright (c) 2009, Andrey Popov
% All rights reserved.

%% Check inputs
if nargin < 2
    error('permm:nargin','permm requires two inputs');
end

[n,m]    = size(A);
if n ~= m
    error('permm:A','The matrix to be permuted should be a square matrix');
end
if n ~= length(idp)
    error('permm:idp','The index vector idp should have as many elements as the size of A');
end
sidp = sort(idp(:))';
if any((1:n) - sidp)
    error('permm:sidp','For a n x n matrix A, the index vector idp should contain the numbers\n1:n in the desired permutation order');
end

%% Perform permuation
P = eye(n);
P = P(:,idp);

B = P'*A*P;
end
