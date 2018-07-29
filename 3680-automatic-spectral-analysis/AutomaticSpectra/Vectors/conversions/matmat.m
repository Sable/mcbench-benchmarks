function [mm, sizb] = matmat(linmap,siz,varargin)

%MATMAT Matrix of a linear mapping from a matrix to a matrix.
%   MM = MATMAT(L,SIZ) constructs a matrix-representation of
%   a linear mapping L from a matrix capital A to a matrix. L is a string
%   containing the desired linear mapping working on the matrix CAPITAL A.
%   SIZ contains the size vector [M N ...] of the domain matrix A. The
%   matrix MM operates on the column vector representation of A and yields
%   the column vector representation of the image matrix B.
%   Thus the linear mapping
%   B = L(A)
%   translates into
%   MAT2VEC(B) = MM*MAT2VEC(A,SIZB),
%   where SIZB is the size of the image space.
%
%   The translation of the vector represenation to the matrix represention
%   is obtained with VEC2MAT:
%   B = VEC2MAT(MM*MAT2VEC(A)).
%
%   Important: The linear mapping L must contain the domain matrix CAPITAL A.
%
%   [MM SIZB] = MATMAT(L,SIZ) also yields the size SIZB of the image space.
%
%   Example:
%   Transposition is a linear mapping from a matrix to a matrix
%   B = A' or B = CTRANSPOSE(A).
%   The matrixmatrix for a 2x3-matrix can be calculated by:
%   [MM SIZB] = MATMAT('CTRANSPOSE(A)',[2 3])
%   and so an alternative way to calculate the transpose of A is given by:
%   B = VEC2MAT(MM*MAT2VEC(A),SIZB).
%
%   MM = MATMAT(L,SIZ,...) allows additional arguments to be passed on to L.
%
%   Example:
%   The matrixmatrix MM for the linear mappings G1 and G2: B = A*G2*G1 is
%   calculated as:
%   MM = MATMAT('A*varargin{2}*varargin{1}',[M N],G1,G2)
%
%   See also MAT2VEC, VEC2MAT, SIZE

%S. de Waele, april 2001.

%Determination of the size of the function value B
A = zeros(siz); A(1,1) = 1;
B = eval(linmap); sizb = size(B);
mm = zeros(prod(sizb),prod(siz));

for lus = 1:prod(siz),
   A = zeros(siz);
   A(lus) = 1;
   r = eval(linmap);
   mm(:,lus) = r(:);
end