function B = BoundMirrorEnsure(A)
% Ensure mirror boundary condition
%
% The number of rows and columns of A must be greater than 2
%
% for example (X means value that is not of interest)
% 
% A = [
%     X  X  X  X  X   X
%     X  1  2  3  11  X
%     X  4  5  6  12  X 
%     X  7  8  9  13  X 
%     X  X  X  X  X   X
%     ]
%
% B = BoundMirrorEnsure(A) will yield
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

if (m<3 | n<3) 
    error('either the number of rows or columns is smaller than 3');
end

yi = 2:m-1;
xi = 2:n-1;
B = A;
B([1 m],[1 n]) = B([3 m-2],[3 n-2]);  % mirror corners
B([1 m],xi) = B([3 m-2],xi);          % mirror left and right boundary
B(yi,[1 n]) = B(yi,[3 n-2]);          % mirror top and bottom boundary
