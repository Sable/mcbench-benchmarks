function x = ThomasAlgorithm(TriDiag, d)

%**************************************************************************
%
% Simplified form of the Gaussian Elimination for a tridaigonal matrix
% based on the algorithm by Llewellyn Thomas.
%
% solves a_i x_i-1 + b_i x_i + c x_i+1 = d_i
%
% http://en.wikipedia.org/wiki/Tridiagonal_matrix_algorithm
%
% Inputs:
%        TriDiag - triagonal matrix components
%        d - known elements
%
% Outputs:
%        x - solved unknowns
%
% Ahmos Sansom - May 2010
%
%**************************************************************************

% Get number of elements.
n = size (TriDiag,1);

% initialise 
x = zeros(n,1);

w = TriDiag(:,2);

for i=2:n
    T = TriDiag(i,1) / w(i-1);
    w(i) = w(i) - TriDiag(i-1,3) * T;
    d(i) = d(i) - d(i-1) * T;
end

% back substitution
x(n) = d(n) / w(n);

for i = n-1:-1:1
    x(i) = ( d(i) - TriDiag(i,3) * x(i+1) ) / w(i);
end

