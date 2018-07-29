function veins = huang_wide_line(img,fvr,r,t,g)
% Wide Line Detector

% Parameters:
%  img - Input vascular image
%  fvr - Binary mask of the finger region
%  r   - Radius of the circular neighbourhood region
%  t   - Neigborhood threshold
%  g   - Sum of neigbourhood threshold

% Returns:
%  veins - Binary vein image

% Reference:
% Finger-vein authentication based on wide line detector and pattern 
%    normalization
% B. Huang, Y. Dai, R. Li, D. Tang and W. Li
% 20th International Conference on Pattern Recognition (ICPR), 2010 
% doi: 10.1109/ICPR.2010.316

% Author:  Bram Ton <b.t.ton@alumnus.utwente.nl>
% Date:    13th March 2012
% License: Simplified BSD License

% Check image type
if (~(isa(img,'uint8') || isa(img,'uint16')))
    disp('Image must be of type uint8 or uint16')
end

[X,Y] = meshgrid(-r:r,-r:r);
N = X.^2 + Y.^2 <= r^2; % Neighbourhood mask

veins = zeros(size(img));
for i=r+1:size(img,1)-r
    for j=r+1:size(img,2)-r
        s = ((img(i-r:i+r,j-r:j+r) - img(i,j)) <= t);
        m = sum(sum(s.*N));
        veins(i,j) = m <= g;
    end
end

% Mask the vein image with the finger region
veins = veins.*fvr;