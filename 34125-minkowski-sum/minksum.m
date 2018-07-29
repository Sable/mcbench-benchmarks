function [S,D]=minksum(A,B)
% MINKSUM Minkowski sum of two arrays
%   S=MINKSUM(A,B) produces the Minkowski sum of two sets A and B
%   in Euclidean space, the result being the addition of every element
%   of A to every element of B.
%
%   [S,D]=MINKSUM(A,B) returns the Minkowski sum S, and also the
%   multiplicity of each element in S.
%
%   The number of columns represent the dimensionality. An array of M points
%   in N-D space is an MxN array. A vector of 1D values is a column vector.
%
%   If the sizes of A and B are MAxN and MBxN respectively, then the size
%   of S will be at most (MA*MB)xN
% 
%   Example:
%     A=[1 1; 2 1; 2 2; 1 2]; B=[3 3; 4 3; 4 4; 3 4];
%     [S,D]=minksum(A,B);
%     plot(A(:,1),A(:,2),'*',B(:,1),B(:,2),'s',S(:,1),S(:,2),'d')
%     axis([0 7 0 7])
%

%   Mike Sheppard
%   Last Modified: 7-Dec-2011


if nargin<2
    error('Requires two inputs');
end
szA=size(A); szB=size(B);
if (szA(2)~=szB(2)) || numel(szA)>2 || numel(szB)>2
    error('Input arrays must be MxN arrays, with equal N');
end

%Pre-allocate memory
S=zeros(szA(1)*szB(1),szA(2));

%Loop through each dimension
for k=1:szA(2)
   temp=bsxfun(@plus,A(:,k),B(:,k)');
   S(:,k)=temp(:);
end

%Take unique for each row
[S,I,J]=unique(S,'rows');
D=histc(J,1:length(I));

end
