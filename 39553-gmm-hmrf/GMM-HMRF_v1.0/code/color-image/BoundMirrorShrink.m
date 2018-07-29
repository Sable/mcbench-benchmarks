%%  Shrink the matrix using mirror boundary condition
%   A: input matrix
%   B: output matrix

function B = BoundMirrorShrink(A)
[m,n] = size(A);
yi = 2:m-1;
xi = 2:n-1;
B = A(yi,xi);

