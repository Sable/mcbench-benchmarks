function iHelix=snailMatIndex(inMatDims)
%% snailMatIndex
% The function calculates the snail/helix indexing of a matrix.
%
%% Syntax
%  iHelix=snailMatIndex(inMatDims);
%
%% Description
% The iHelix returns indexes, allowing to treat matrix elemnt in a clock-wise
% (snail/escargot/helix) order.
%
%% Input arguments:
%	inMatDims- the indexed matrix dimentions.
%
%% Output arguments
%  iHelix-  a row vector including helix/snail ordered elements.
%
%% Issues & Comments
%
%% Example
% iMat=reshape(1:15, 3, 5) 
% iHelix=snailMatIndex(size(iMat))
%
%% See also
%
%% Revision history
% First version: Nikolay S. 2012-08-27.
% Last update:   Nikolay S. 2012-08-27.
%
% *List of Changes:*

if length(inMatDims)==1
   inMatDims=repmat(inMatDims, 1, 2);
end

nElemems=inMatDims(1)*inMatDims(2);
indMat =reshape(1:nElemems, inMatDims);
iHelix=[];

while ~isempty(indMat)
   iHelix=cat( 2, iHelix, indMat(1, :) );
   indMat(1, :)=[];        % remove the current top row
   indMat=rot90(indMat);   % rotate index matrix 90° clock-wise
end