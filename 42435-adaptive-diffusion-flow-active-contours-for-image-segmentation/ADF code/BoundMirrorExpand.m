function B = BoundMirrorExpand(A)
% Expand the matrix using mirror boundary condition
% 
% for example 
%
% A = [
%     1  2  3  11
%     4  5  6  12
%     7  8  9  13
%     ]
%
% B = BoundMirrorExpand(A) will yield
%
%     5  4  5  6  12  6
%     2  1  2  3  11  3
%     5  4  5  6  12  6 
%     8  7  8  9  13  9 
%     5  4  5  6  12  6
%

% Chenyang Xu and Jerry L. Prince, 9/9/1999
% http://iacl.ece.jhu.edu/projects/gvf

[m,n] = size(A);
yi = 2:m+1;
xi = 2:n+1;
B = zeros(m+2,n+2);
B(yi,xi) = A;
B([1 m+2],[1 n+2]) = B([3 m],[3 n]);  % mirror corners
B([1 m+2],xi) = B([3 m],xi);          % mirror left and right boundary
B(yi,[1 n+2]) = B(yi,[3 n]);          % mirror top and bottom boundary
