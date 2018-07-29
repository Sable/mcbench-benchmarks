%%  Expand the matrix using mirror boundary condition
%   A: input matrix
%   B: output matrix

function B = BoundMirrorExpand(A)
[m,n] = size(A);
yi = 2:m+1;
xi = 2:n+1;
B = zeros(m+2,n+2);
B(yi,xi) = A;
B([1 m+2],[1 n+2]) = B([3 m],[3 n]);  
B([1 m+2],xi) = B([3 m],xi);          
B(yi,[1 n+2]) = B(yi,[3 n]);       