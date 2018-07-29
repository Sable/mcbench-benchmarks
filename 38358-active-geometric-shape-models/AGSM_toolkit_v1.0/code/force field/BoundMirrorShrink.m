function B = BoundMirrorShrink(A)
% Shrink the matrix to remove the padded mirror boundaries
%
% for example 
%
% A = [
%     5  4  5  6  12  6
%     2  1  2  3  11  3
%     5  4  5  6  12  6 
%     8  7  8  9  13  9 
%     5  4  5  6  12  6
%     ]
% 
% B = BoundMirrorShrink(A) will yield
%
%     1  2  3  11
%     4  5  6  12
%     7  8  9  13

% Chenyang Xu and Jerry L. Prince, 9/9/1999
% http://iacl.ece.jhu.edu/projects/gvf

[m,n] = size(A);
yi = 2:m-1;
xi = 2:n-1;
B = A(yi,xi);

