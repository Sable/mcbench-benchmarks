%%  index to i and j conversion
%   ind: index
%   m: height of image
%   i, j: image coordinates

function [i j]=ind2ij(ind,m)
i=mod(ind-1,m)+1;
j=floor((ind-1)/m)+1;