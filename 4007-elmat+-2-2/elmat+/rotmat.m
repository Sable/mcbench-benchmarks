function B=rotmat(A,n,dim)
%ROTMAT  Rotate matrix along specified dimension.
%   ROTMAT(X), returns X.
%   ROTMAT(X,N), moves elements in matrix X with N steps in
%      a wrapping/rotating fashion. Rotation will be done row-wise.
%      Positive N will mean that elements are moved towards higher
%      row indicies. Last element(s) will be moved to the first row,
%      aso. Negative N will make the elements move upwards towards
%      lower row indicies. First element(s) will be moved to the last
%      row, aso. If N is zero or empty, no rotation will occur
%      and X will be returned.
%   ROTMAT(X,N,DIM), rotates matrix elements along dimension DIM.
%      If DIM is a singleton dimension, X will be returned.
%      Likewise if DIM < 1 or DIM > ndims(X), nothing will happen.
%      N must be scalar valued.
%
%   Examples:
%      X=rand(3,3,3)          %X is 3x3x3.
%      rotmat(X,1)            %rotates one step along rows.
%      rotmat(X,-2)           %rotates two steps along rows, opposite direction.
%      rotmat(X,1,2)          %rotates one step along columns.
%      rotmat(X,1,3)          %rotates one step along third dimension.
%
%   See also DELMAT, INSMAT, SHIFTMAT, REPMAT, RESHAPE, FLIPDIM.

% Copyright (c) 2003-10-28, B. Rasmus Anthin.
% Revision 2003-10-29.
% GPL license, freeware.

error(nargchk(1,3,nargin))
if nargin<2, n=0;end                    %do nothing
if isempty(n), n=0;end
if prod(size(n))~=1, error('N must be a scalar.'),end
n=round(n);
if nargin<3, dim=1;end                  %rotate row vectors
if dim<1, dim=ndims(A)+1;end            %if less than one, do nothing
dims=[dim:max(ndims(A),dim) 1:dim-1];
if dims(1)<=ndims(A) & n
   A=permute(A,dims);                             %move dimension to front
   sizA=size(A);                                  %get dimension sizes
   A=reshape(A,[sizA(1) prod(sizA(2:end))]);      %reshape to a 2-D matrix
   n=rem(n-1,sizA(1))+1;                          %wrapping
   idx=1:sizA(1);                                 %the row indices
   if n<0
      idx=[idx(1-n:end) idx(1:-n)];               %rotate row indices (negative rotation)
   else
      idx=[idx(end-n+1:end) idx(1:end-n)];        %rotate row indices (positive rotation)
   end
   B=A(idx,:);
   B=reshape(B,[size(B,1) sizA(2:end)]);          %back to previous shape minus removed vectors
   B=ipermute(B,dims);                            %replace dimensions to initial location
else
   B=A;
end