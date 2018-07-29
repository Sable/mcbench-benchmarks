function B=shiftmat(A,n,dim,pad)
%SHIFTMAT  Shift matrix along specified dimension.
%   SHIFTMAT(X), returns X.
%   SHIFTMAT(X,N), moves elements in matrix X with N steps. The trailing
%      elements becomes zeros. Shifting will be done row-wise.
%      Positive N will mean that elements are moved towards higher
%      row indicies. First row will be filled with zeros,
%      aso. Negative N will make the elements move upwards towards
%      lower row indicies. Last row will be filled with zeros,
%      aso. If N is zero or empty, no shifting will occur
%      and X will be returned.
%   SHIFTMAT(X,N,DIM), shifts matrix elements along dimension DIM.
%      If DIM is a singleton dimension, X will be returned.
%      Likewise if DIM < 1 or DIM > ndims(X), nothing will happen.
%      N must be scalar valued.
%   SHIFTMAT(X,N,DIM,PAD), uses PAD to pad the trailing elements with
%      another value rather than zeros.
%      PAD must be scalar valued.
%
%   Examples:
%      X=rand(3,3,3)          %X is 3x3x3.
%      shiftmat(X,1)          %shifts one step down.
%      shiftmat(X,-2)         %shifts two steps up.
%      shiftmat(X,1,2)        %shifts ones step right.
%      shiftmat(X,1,3)        %shifts one step "down" along 3:rd dimension.
%      shiftmat(X,-2,2,NaN)   %shifts two steps left with trailing NaNs.
%
%   See also DELMAT, INSMAT, ROTMAT, REPMAT, RESHAPE, FLIPDIM.

% Copyright (c) 2003-10-28, B. Rasmus Anthin.
% Revision 2003-10-29.
% GPL license, freeware.

error(nargchk(1,4,nargin))
if nargin<2, n=0;end                    %do nothing
if isempty(n), n=0;end
if prod(size(n))~=1, error('N must be a scalar.'),end
n=round(n);
if nargin<3, dim=1;end                  %rotate row vectors
if dim<1, dim=ndims(A)+1;end            %if less than one, do nothing
if nargin<4, pad=0;end                  %trailing elements are zeros as default
if prod(size(pad))~=1, error('PAD must be a scalar.'),end
dims=[dim:max(ndims(A),dim) 1:dim-1];
if dims(1)<=ndims(A) & n
   A=permute(A,dims);                             %move dimension to front
   sizA=size(A);                                  %get dimension sizes
   A=reshape(A,[sizA(1) prod(sizA(2:end))]);      %reshape to a 2-D matrix
   idx=1:sizA(1);                                 %the row indices
   if n<0
      idx=idx(1-n:end);                           %remove low valued indices
      B=A(idx,:);                                 %truncate matrix
      B=[B;pad*ones(min(-n,sizA(1)),prod(sizA(2:end)))];    %pad with zeros (or PAD)
   elseif n>0
      idx=idx(1:end-n);                           %remove high valued indices
      B=A(idx,:);                                 %truncate matrix
      B=[pad*ones(min(n,sizA(1)),prod(sizA(2:end)));B];     %pad with zeros (or PAD)
   end
   B=reshape(B,[size(B,1) sizA(2:end)]);          %back to previous shape minus removed vectors
   B=ipermute(B,dims);                            %replace dimensions to initial location
else
   B=A;
end