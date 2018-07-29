function showCoinSeg(img, coinseg, edgeColor, lineStyle)
% function showCoinSeg(CoinSeg, coinseg, edgeColor, lineStyle)
%
% purpose:
%   Utility to display segmentation parameters found by functions like
%   SegScaleAccHT on an image. A circle is draw at the segmentation.
% parameters:
%  IN:
%    img       image
%    coinseg   segmentation triplet [radius, centerY, centerX]
%    edgeColor color of the coircle to draw (optional)
%              default 'r' (red)
%    edgeColor line style of the coircle to draw (optional)
%              default '--'
%
% Example: (read coin image, segment coin and show segmentation)
%              img = imread('img1.png');         
%              segdata = showCoinSeg(img, segScaleAccHT(img));     
%             



%
% (C) Christian Kotz 2007
%
% $Id: showCoinSeg.m,v 1.1 2008/04/25 17:39:40 ck Exp $
% author:  $Author: ck $
% date:    $Date: 2008/04/25 17:39:40 $
% version: $Revision: 1.1 $
% history:
% $Log: showCoinSeg.m,v $
% Revision 1.1  2008/04/25 17:39:40  ck
% added example
%
% Revision 1.2  2008/04/22 12:30:50  ck
% _
%
% Revision 1.1  2008/04/22 12:29:25  ck
% _
%
%

if nargin < 3
    edgeColor = 'r';
end

if nargin < 4
    lineStyle = '--';
end

r = coinseg(1);
y = coinseg(2);
x = coinseg(3);

imshow(img);
hold on;

rectangle('Position', [x-abs(r),y-abs(r),abs(2*r),abs(2*r)], 'Curvature', [1,1], ...
    'EdgeColor', edgeColor, 'LineStyle', lineStyle);
hold off
