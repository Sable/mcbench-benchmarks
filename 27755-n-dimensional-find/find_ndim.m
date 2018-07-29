function varargout = find_ndim( BW, dim, firstOrLast )
%FIND_NDIM   Finds first/last nonzero element indices along a dimension.
%   I = FIND_NDIM(BW,DIM) returns the subscripts of the first nonzero
%   elements of BW along the dimension DIM. Output I will contain zeros in
%   element locations where no nonzero elements were found
%
%   I = FIND_NDIM(BW,DIM,'first) is the same as I = FIND_NDIM(BW,DIM).
%
%   I = FIND_NDIM(BW,DIM,'last') returns the subscripts of the last nonzero
%   elements of BW along the dimension DIM.
%
%   [I,MASK] = FIND_NDIM(BW,DIM,...) also returns a MASK the same size as
%   BW with only the first/last pixels in dimension DIM on.
%
%     Example 1:
%         If   X = [0 1 0
%                   1 1 0]
%         then find_ndim(X,1) returns [2 1 0], find_ndim(X,1,'last')
%         returns [2 2 0], and find_ndim(X,2) returns [2 1]';
%
%     Example 2:
%         I = imread('rice.png');
%         greyIm = imadjust(I - imopen(I,strel('disk',15)));
%         BW = imclearborder(bwareaopen(im2bw(greyIm, graythresh(greyIm)), 50));
%         topMostOnInds = find_ndim(BW, 1, 'first');
%         rightMostOnInds = find_ndim(BW, 2, 'last');
%         figure, imshow(BW), hold on
%         plot(1:size(BW,2), topMostOnInds, 'r.')
%         plot(rightMostOnInds, 1:size(BW,1), '.b')
%
%   See also MAX, FIND.

% Written by Sven Holcombe

assert(nargin>=2,'Insufficient arguments')

% Handle non-logical input
if ~isa(BW,'logical')
    BW = BW~=0;
end

% Determine whether we're finding first/last entry
if nargin < 3 || strcmpi(firstOrLast,'first')
    firstOrLast = 'first';
elseif nargin == 3 && strcmpi(firstOrLast,'last')
    BW = flipdim(BW,dim); % If they asked to find last entry, flip in that direction
else
    error('find_ndim:searchOption','Invalid search option. Must be ''first'' or ''last''') 
end

% Hijack the max function. Input is logical so max idx will be first pixel
[~, foundPx] = max(BW,[],dim); 
foundPx(~any(BW,dim)) = 0; % Account for all-zero entries by setting output to 0

% If they asked to find last entry, account for previously flipping BW
if strcmpi(firstOrLast,'last')
    foundPx(foundPx~=0) = size(BW,dim)+1 - foundPx(foundPx~=0);
end
varargout{1} = foundPx;

% If they asked for a full MASK of found pixels:
if nargout==2
    indsSz = ones(1,ndims(BW));
    indsSz(dim) = size(BW,dim);
    varargout{2} = bsxfun(@eq, foundPx, reshape(1:size(BW,dim), indsSz));
end