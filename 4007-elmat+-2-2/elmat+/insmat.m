function B=insmat(A,v,Ii,dim)
%INSMAT  Insert vector or matrix entries into matrix.
%   INSMAT(X), returns X.
%   INSMAT(X,V), tries to append matrix X with vector (or matrix) V.
%   INSMAT(X,V,I), inserts row vectors V at rows I in matrix X.
%      If I is an empty vector, X will be returned.
%      In the indices I, only real parts are concidered and if they
%      are not integers then they will be rounded off. Indices can be a
%      logical array (see examples).
%   INSMAT(X,V,I,DIM),  inserts vectors V along dimension DIM.
%      If DIM < 1 or DIM > ndims(X), nothing will happen.
%
%   The vectors in V are arranged row-wise.
%   If V only have one row and there are multiple indices, then 
%   V will be inserted repeatedly into those indices.
%   Insertion is performed in a push-down fashion.
%   The element(s) at an index of insertion are thus pushed downwards.
%
%   Examples:
%      X=rand(2,2,2)                  %X is 2x2x2.
%      Y=insmat(X,[NaN Inf],2)        %inserts [NaN Inf] into row 2.
%      Y=insmat(X,[NaN Inf -1 -2],2)  %inserts [NaN Inf -1 -2] into row 2.
%      size(Y)                        %Y will be 3x2x2.
%      Y=insmat(X,-[1 1;2 2],[1 3],2) %inserts vectors -[1 1] and -[2 2]
%                                     %into column 1 and 2 respectively. Same as:
%      Y=insmat(X,-[1 1 1 1;2 2 2 2],[1 3],2)
%      size(Y)                        %Y will be 2x4x2.
%         %Inputs NaNs in 3rd dim at indices 2 and 3:
%      Y=insmat(X,repmat(NaN,1,4),[2 3],3)
%      size(Y)                        %Y will be 2x2x4.
%      X=1:3
%      insmat(X,NaN,X==3,2)           %inserts NaN at the location where X==3.
%      X=[1 1 2;1 2 3;2 3 3;3 3 3]
%         %Inputs zero-vector at row locations containing both numbers 1 and 2:
%      insmat(X,[0 0 0],any(X==2,2) & any(X==1,2),1)
%
%   See also DELMAT, ROTMAT, SHIFTMAT, REPMAT, RESHAPE, FLIPDIM.

% Copyright (c) 2003-09-24, B. Rasmus Anthin.
% Revision 2003-10-27, 2003-10-29.
% GPL license, freeware.

error(nargchk(1,4,nargin))
sizA=size(A);
flag=1;
if nargin<2, v=zeros([0 sizA(2:end)]);end
if nargin<3, Ii=sizA(1)+1;end           %try to append to rows
if islogical(Ii), Ii=find(Ii);end       %if index is a logical object
if nargin<4, dim=1;end                  %remove row vectors
if dim<1, dim=1; flag=0;end             %do nothing
Ii=round(real(Ii(:)'));                 %choose nearest integer indices and only concider real values
Ii=Ii(Ii>0 & Ii<=size(A,dim)+1);        %select indices that are not outside the dimension range
if isempty(Ii), flag=0; Ii=1;end        %do nothing
Itot=1:size(A,dim);                     %all indices of dimension to work along
Ii2=Ii+(0:length(Ii)-1);                %input indices for expanded matrix
Itot2=setdiff(1:size(A,dim)+length(Ii),Ii2);    %indices for remaining elements in expanded matrix
dims=[dim:max(ndims(A),dim) 1:dim-1];
if flag
   A=permute(A,dims);                             %move dimension to front
   sizA=size(A);                                  %get dimension sizes for A
   sizv=size(v);                                  %get dimension sizes for v
   restA=prod(sizA(2:end));                       %rest of dimensions -> columns
   restv=prod(sizv(2:end));                       %rest of dimensions -> columns
   A=reshape(A,[sizA(1) restA]);                  %reshape to a 2-D matrix
   B=zeros([sizA(1)+length(Ii) restA]);           %expanding matrix
   B(Itot2,:)=A(Itot,:);                          %keeping values
   iv=permute(v,dims);                            %permute vectors same way as the matrix
   iv=reshape(v,[sizv(1) restv]);                 %reshape vectors same way as the matrix
   if size(B,2)>size(iv,2)                        %size of the vectors doesn't match with all extra dimensions
      cdim=round(size(B,2)/size(v,2));
      iv=repmat(iv,[1 cdim]);                     %extending columns
   end
   if length(Ii)>size(iv,1)                       %if having one vector inserted at multiple indices
      rdim=round(length(Ii)/size(v,1));
      iv=repmat(iv,[rdim 1]);                     %extending rows
   end
   B(Ii2,:)=iv;                                   %inserting "row-vectors"
   B=reshape(B,[size(B,1) sizA(2:end)]);          %back to previous shape minus removed vectors
   B=ipermute(B,dims);                            %replace dimensions to initial location
else
   B=A;
end