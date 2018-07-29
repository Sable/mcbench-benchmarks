function [iind,jind,numberofpixels]=fastcentroid(X)
%
%
% [iind,jind,numberofpixels]=fastcentroid(X)
% returns the centroid coordinates for the connected components in BW (iind,jind).
% and the number of pixels of each component (numberofpixels)
%
% input:
% X bynary image
%
% output:
%
% iind [length = number of connected components ]
% jind [length = number of connected components ]
% numberofpixels [length = number of connected components ]
%
%
% it is faster than:
%
%
%bwmorph('shrink',Inf) 
%imfeature(L,'centroid')
%
%
% software developed by:
% Marcelino Sanchez Gonzalez (C) May 2002
% e-mail:sanchezmarcelino@hotmail.com
% 
%
%
XMLABEL=BWLABEL(X);
XMLABELS=sparse(XMLABEL);
maxXM=max(XMLABEL(:));

for i=1:maxXM
    [ii,jj]=find(XMLABELS==i);
    numberofpixels(i)=length(ii);
    iind(i)=mean(ii);
    jind(i)=mean(jj);
end