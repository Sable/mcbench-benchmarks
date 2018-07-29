function B=delmat(A,idx,dim)
%DELMAT  Delete vector or matrix entries from matrix.
%   DELMAT(X), returns X.
%   DELMAT(X,I), removes the row vectors at rows I in matrix X.
%      If I is an empty vector, X will be returned.
%      In the indices I, only real parts are concidered and if they
%      are not integers then they will be rounded off. Indices can be a
%      logical array (see examples).
%   DELMAT(X,I,DIM), removes vector entries along dimension DIM.
%      If DIM is a singleton dimension, X will be returned.
%      Likewise if DIM < 1 or DIM > ndims(X), nothing will happen.
%
%   Examples:
%      X=rand(4,3,2)            %X is 4x3x2.
%      Y=delmat(X,[1 3])        %removes row 1 and 3.
%      size(Y)                  %Y will be 2x3x2.
%      Y=delmat(X,2:3,2)        %removes column 2 and 3.
%      size(Y)                  %Y will be 4x1x2.
%      Y=delmat(X,2,3)          %removes "vector" 2 along dimension 3.
%      size(Y)                  %Y will be 4x3.
%      X=1:5
%      delmat(X,1<X & X<5,2)    %returns [1 5].
%      X=[1 1 1;1 1 2;1 2 3;2 3 3;3 3 3]
%      delmat(X,any(X==2,2),1)  %returns [1 1 1;3 3 3].
%
%   See also INSMAT, ROTMAT, SHIFTMAT, REPMAT, RESHAPE, FLIPDIM.

% Copyright (c) 2003-09-24, B. Rasmus Anthin.
% Revision 2003-10-27, 2003-10-29.
% GPL license, freeware.

error(nargchk(1,3,nargin))
if nargin<2, idx=[];end                 %do nothing
if islogical(idx), idx=find(idx);end    %if index is a logical object
if nargin<3, dim=1;end                  %remove row vectors
if dim<1, dim=ndims(A)+1;end            %if less than one, do nothing
idx=round(real(idx(:)'));               %choose nearest integer indices and only concider real values
tot=1:size(A,dim);
ikeep=setdiff(tot,idx);                 %indicies for vectors to keep
dims=[dim:max(ndims(A),dim) 1:dim-1];
if dims(1)<=ndims(A)
   A=permute(A,dims);                             %move dimension to front
   sizA=size(A);                                  %get dimension sizes
   A=reshape(A,[sizA(1) prod(sizA(2:end))]);      %reshape to a 2-D matrix
   B=A(ikeep,:);                                  %remove "row-vectors"
   B=reshape(B,[size(B,1) sizA(2:end)]);          %back to previous shape minus removed vectors
   B=ipermute(B,dims);                            %replace dimensions to initial location
else
   B=A;
end