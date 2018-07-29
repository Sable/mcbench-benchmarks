function cmap = CMRmap(M)
% Create a monochrome-compatible colour map
% 
%   cmap = CMRmap
%   cmap = CMRmap(M)
% 
%   cmap = CMRmap returns a colour map CMAP (varying black -
%   purple - red - yellow - white) that is monochrome-
%   compatible, i.e. it produces a monotonic greyscale
%   colour map. CMAP is size Mx3, where M is the length of
%   the current figure's colormap. If no figure exists,
%   MATLAB creates one.
% 
%   cmap = CMRmap(M) sets the colormap length to M.
% 
%   The map is a slight modification to that suggested in
%   [1].
% 
%   EXAMPLE
% 
%   figure;
%   imagesc(peaks(1000));
%   colormap(CMRmap(256));
%   axis image;
%   colorbar
% 
%   REFERENCE
% 
%   [1] Rappaport, C. 2002: "A Color Map for Effective
%   Black-and-White Rendering of Color Scale Images", IEEE
%   Antenna's and Propagation Magazine, Vol.44, No.3,
%   pp.94-96 (June).
% 
% See also GRAY.

% !---
% ==========================================================
% Last changed:     $Date: 2012-12-20 14:18:42 +0000 (Thu, 20 Dec 2012) $
% Last committed:   $Revision: 232 $
% Last changed by:  $Author: ch0022 $
% ==========================================================
% !---

% default colormap size
if nargin < 1, M = size(get(gcf,'colormap'),1); end

% reference colour map
% adapted from article to produce more linear luminance
CMRref=...
    [0    0    0;
     0.1  0.1  0.35;
     0.3  0.15 0.65;
     0.6  0.2  0.50;
     1    0.25 0.15;
     0.9  0.55  0;
     0.9  0.75 0.1;
     0.9  0.9  0.5;
     1    1    1];

% Interpolate colormap to colormap size
cmap = zeros(M,3);
for c = 1:3
    cmap(:,c) = interp1((1:9)',CMRref(:,c),linspace(1,9,M)','spline');
end

% Limit to range [0,1]
cmap = cmap-min(cmap(:));
cmap = cmap./max(cmap(:));

% [EOF]
