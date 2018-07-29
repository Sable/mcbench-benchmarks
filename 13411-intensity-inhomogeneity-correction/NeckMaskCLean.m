function Imask4 = NeckMaskCLean(Imask);
% NeckMaskCLean:    clean a neck mask by removing small elements and opening
%
%   Imask4 = NeckMaskCLean(Imask);
%
% OS CWRU, 19-jan-04


% --- remove small stuff.
Imask = imopen(Imask,strel('disk',1,0));

% --- keep the biggest CCA
Imask2 = bwlabel(Imask,8);
s  = regionprops(Imask2, 'Area');
area = [s.Area];
[dummy,idx] = max(area);
Imask3 = (Imask2==idx);

% --- close the holes
Imask4 = imclose(Imask3,strel('disk',2,0));
Imask4 = bwmorph(Imask4,'fill');

% --- take again the max CCA
% Imask2 = bwlabel(Imask4,8);
% s  = regionprops(Imask2, 'Area');
% area = [s.Area];
% [dummy,idx] = max(area);
% Imask4 = (Imask2==idx);